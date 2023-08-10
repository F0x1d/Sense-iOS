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
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60 * 10
        
        afSession = Alamofire.Session(configuration: configuration)
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
            afSession.request(requestUrl, method: .post) { request in
                try request.setJSONBody(body)
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
        
        let streamTask = afSession.streamRequest(requestUrl, method: .post) { request in
            try request.setJSONBody(body)
            modifier(&request)
        }.streamTask()
        
        var content = ""
        var cancelled = false
        for await stream in streamTask.streamingStrings() {
            if let string = stream.value {
                if let error = try? JSONDecoder().decode(
                    ErrorResponse.self, 
                    from: string.data(using: .utf8, allowLossyConversion: false)!
                ) {
                    throw ServerError(message: error.error.message)
                }
                
                string
                    .replacingOccurrences(of: "data: ", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .split(separator: "\n")
                    .forEach { line in 
                        if let response = try? JSONDecoder().decode(
                            GenerateMessageResponse.self,
                            from: String(line).data(using: .utf8, allowLossyConversion: false)!
                        ) {
                            content += response.choices.first?.delta?.content ?? ""
                        }
                    }
                
                try await listener(content, &cancelled)
                
                if cancelled { break }
            }
            
            if let error = stream.error {
                throw error
            }
        }
    }
    
    private func parseResponse<T>(_ response: DataResponse<T, AFError>) async throws -> T {
        if let value = response.value {
            return value
        }
        if let error = response.error {
            if let data = response.data {
                throw parseError(data: data) ?? error
            }
            throw error
        }
        throw ServerError(message: "Network error")
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
