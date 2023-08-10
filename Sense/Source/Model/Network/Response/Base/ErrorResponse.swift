//
//  ErrorResponse.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation

struct ErrorResponse: Decodable {
    let error: OpenAIError
    
    struct OpenAIError: Decodable {
        let message: String
    }
}
