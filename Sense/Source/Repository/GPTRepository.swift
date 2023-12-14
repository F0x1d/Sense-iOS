//
//  GPTRepository.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import Factory
import Papyrus

final class GPTRepository: BaseRepository {
    
    @Injected(\.gptAPI) private var gptApi
    @Injected(\.settingsStore) private var settingsStore
    
    func generateImage(prompt: String) async throws -> [String] {
        let backgroundTaskId = await startBackgroundTask()
        defer {
            endBackgroundTaskNonAsync(backgroundTaskId)
        }
        
        let body = GenerateImageRequestBody(
            prompt: prompt,
            n: settingsStore.responsesCount
        )
        
        return try await gptApi.generateImage(body: body).data.map { imageData in 
            imageData.url
        }
    }
    
    func generateMessage(
        messages: [Message]
    ) async throws -> AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, String> {
        let body = GenerateMessageRequestBody(
            messages: messages,
            model: settingsStore.model
        )
                
        return try await stream(
            requestUrl: "https://api.openai.com/v1/chat/completions",
            body: body
        ) { [weak self] request in
            request.setValue("Bearer \(self?.settingsStore.apiKey ?? "")", forHTTPHeaderField: "Authorization")
        }
    }
}
