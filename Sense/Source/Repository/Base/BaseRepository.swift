//
//  BaseRepository.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import Alamofire

@RepositoryActor class BaseRepository {
    
    typealias RequestModifier = (inout URLRequest) -> Void
    typealias StreamDataListener = (String, inout Bool) async throws -> Void
    
    private let afSession: Alamofire.Session
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60 * 10
        
        afSession = Alamofire.Session(configuration: configuration)
        session = URLSession(configuration: configuration)
    }
    
    func get<T : Decodable>(requestUrl: String, resultType: T.Type) async throws -> T {
        let backgroundTaskId = await startBackgroundTask()
        defer {
            endBackgroundTaskNonAsync(backgroundTaskId)
        }
        
        return try await parseResponse(afSession.request(requestUrl).serializingDecodable(resultType).response)
    }
    
    func post<T : Decodable, R : Encodable>(
        requestUrl: String,
        body: R,
        resultType: T.Type,
        _ modifier: @escaping RequestModifier = { _ in }
    ) async throws -> T {
        let backgroundTaskId = await startBackgroundTask()
        defer {
            endBackgroundTaskNonAsync(backgroundTaskId)
        }
                
        return try await parseResponse(
            afSession.request(requestUrl, method: .post, parameters: body, encoder: JSONParameterEncoder.openAI) { request in
                modifier(&request)
            }.serializingDecodable(resultType).response
        )
    }
    
    func stream<R : Encodable>(
        requestUrl: String,
        body: R,
        listener: @escaping StreamDataListener,
        _ modifier: @escaping RequestModifier = { _ in }
    ) async throws {
        let backgroundTaskId = await startBackgroundTask()
        defer {
            endBackgroundTaskNonAsync(backgroundTaskId)
        }
        
        var request = try URLRequest(url: URL(string: requestUrl)!, method: .post)
        request.httpBody = try JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        modifier(&request)
        
        let (result, response) = try await session.bytes(for: request)
        
        if let response = response as? HTTPURLResponse {
            if !(200...299).contains(response.statusCode) {
                var error = ""
                for try await line in result.lines {
                    error += line
                }
                
                if let errorResponse = try? JSONDecoder().decode(
                    ErrorResponse.self,
                    from: error.data(using: .utf8, allowLossyConversion: false)!
                ) {
                    throw ServerError(message: errorResponse.error.message)
                }
            }
        }
        
        var content = ""
        var cancelled = false
        for try await line in result.lines {
            let formattedLine = line
                .replacingOccurrences(of: "data: ", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let response = try? JSONDecoder().decode(
                GenerateMessageResponse.self,
                from: formattedLine.data(using: .utf8, allowLossyConversion: false)!
            ) {
                content += response.choices.first?.delta?.content ?? ""
            }
            
            try await listener(content, &cancelled)
            
            if cancelled { break }
        }
    }
    
    private func parseResponse<T>(_ response: DataResponse<T, AFError>) async throws -> T {
        if let value = response.value {
            return value
        }
        
        let error = response.error!
        if let data = response.data {
            throw parseError(data: data) ?? error
        }
        throw error
    }
    
    private func parseError(data: Data) -> Error? {
        let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
        if let errorResponse = errorResponse {
            return ServerError(message: errorResponse.error.message)
        }
        return nil
    }
}

@MainActor extension BaseRepository {
    private func startBackgroundTask() async -> UIBackgroundTaskIdentifier {
        var id = UIBackgroundTaskIdentifier.invalid
        id = UIApplication.shared.beginBackgroundTask { [self] in
            endBackgroundTask(id)
        }
        return id
    }
    
    private func endBackgroundTask(_ id: UIBackgroundTaskIdentifier) {
        UIApplication.shared.endBackgroundTask(id)
    }
    
    private nonisolated func endBackgroundTaskNonAsync(_ id: UIBackgroundTaskIdentifier) {
        Task { @MainActor in endBackgroundTask(id) }
    }
}
