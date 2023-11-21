//
//  GPT.swift
//  Sense
//
//  Created by Максим Зотеев on 14.11.2023.
//

import Foundation
import Papyrus

@API
protocol GPT {
    @POST("images/generations")
    func generateImage(body: Body<GenerateImageRequestBody>) async throws -> GenerateImageResponse
}
