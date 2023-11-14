//
//  BaseRepository.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import Factory
import Papyrus

class BaseRepository {
    
    typealias RequestModifier = (inout URLRequest) -> Void
    typealias StreamDataListener = (String, inout Bool) async throws -> Void
    
    let session: URLSession
    
    @Injected(\.decoder) var jsonDecoder
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60 * 10
        
        session = URLSession(configuration: configuration)
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
                
        var request = URLRequest(url: URL(string: requestUrl)!)
        request.httpMethod = "POST"
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
                
                if let errorResponse = try? jsonDecoder.decode(
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
            
            if let response = try? jsonDecoder.decode(
                GenerateMessageResponse.self,
                from: formattedLine.data(using: .utf8, allowLossyConversion: false)!
            ) {
                content += response.choices.first?.delta?.content ?? ""
            }
            
            try await listener(content, &cancelled)
            
            if cancelled { break }
        }
    }
}

@MainActor extension BaseRepository {
    func startBackgroundTask() async -> UIBackgroundTaskIdentifier {
        var id = UIBackgroundTaskIdentifier.invalid
        id = UIApplication.shared.beginBackgroundTask { [self] in
            endBackgroundTask(id)
        }
        return id
    }
    
    func endBackgroundTask(_ id: UIBackgroundTaskIdentifier) {
        UIApplication.shared.endBackgroundTask(id)
    }
    
    nonisolated func endBackgroundTaskNonAsync(_ id: UIBackgroundTaskIdentifier) {
        Task { @MainActor in endBackgroundTask(id) }
    }
}
