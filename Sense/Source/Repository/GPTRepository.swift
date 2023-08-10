//
//  GPTRepository.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation

final class GPTRepository: BaseRepository {
    
    func generateImage(prompt: String, count: Int, apiKey: String) async throws -> [String] {
        let body = GenerateImageRequestBody(
            prompt: prompt,
            n: count
        )
        
        return try await openAIPost(
            requestUrl: "https://api.openai.com/v1/images/generations", 
            body: body, 
            apiKey: apiKey,
            resultType: GenerateImageResponse.self
        ).data.map { imageData in imageData.url }
    }
    
    func generateMessage(
        model: String,
        messages: [Message],
        apiKey: String,
        listener: @escaping StreamDataListener
    ) async throws {
        let body = GenerateMessageRequestBody(
            messages: messages,
            model: model
        )
        
        try await openAIStream(
            requestUrl: "https://api.openai.com/v1/chat/completions", 
            body: body, 
            apiKey: apiKey, 
            listener: listener
        )
    }
    
    private func openAIPost<T : Decodable>(
        requestUrl: String,
        body: Encodable,
        apiKey: String,
        resultType: T.Type
    ) async throws -> T {
        try await post(
            requestUrl: requestUrl,
            body: body, 
            resultType: resultType
        ) { $0.appendApiKey(apiKey) }
    }
    
    private func openAIStream(
        requestUrl: String,
        body: Encodable,
        apiKey: String,
        listener: @escaping StreamDataListener
    ) async throws {
        try await stream(
            requestUrl: requestUrl,
            body: body, 
            listener: listener
        ) { $0.appendApiKey(apiKey) }
    }
}
