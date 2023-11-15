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
    
    private let gptApi: GPTAPI

    private let settingsStore: SettingsStore
        
    override init() {
        let settingsStore = Container.shared.settingsStore()
        let provider = Provider(baseURL: "https://api.openai.com/v1/").modifyRequests { builder in
            builder.addAuthorization(.bearer(settingsStore.apiKey))
        }
        
        self.gptApi = GPTAPI(provider: provider)
        self.settingsStore = settingsStore
        super.init()
    }
    
    func generateImage(prompt: String) async throws -> [String] {
        let backgroundTaskId = await startBackgroundTask()
        defer {
            endBackgroundTaskNonAsync(backgroundTaskId)
        }
        
        let body = GenerateImageRequestBody(
            prompt: prompt,
            n: settingsStore.responsesCount
        )
        
        let res = try await gptApi.generateImage(body: body)
        try checkResponseForError(res)
        
        return try res.decode(GenerateImageResponse.self, using: jsonDecoder).data.map { imageData in imageData.url }
    }
    
    func generateMessage(
        messages: [Message]
    ) async throws -> AsyncCompactMapSequence<AsyncLineSequence<URLSession.AsyncBytes>, String> {
        let body = GenerateMessageRequestBody(
            messages: messages,
            model: settingsStore.model.apiModel
        )
                
        return try await stream(
            requestUrl: "https://api.openai.com/v1/chat/completions",
            body: body
        ) { [weak self] request in
            request.setValue("Bearer \(self?.settingsStore.apiKey ?? "")", forHTTPHeaderField: "Authorization")
        }
    }
    
    private func checkResponseForError(_ response: Response) throws {
        guard response.error != nil else { return }
        
        guard let data = response.body else {
            try response.validate()
            return
        }
        
        let errorResponse = try jsonDecoder.decode(ErrorResponse.self, from: data)
        throw ServerError(message: errorResponse.error.message)
    }
}
