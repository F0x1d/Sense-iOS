//
//  URLRequestExtensions.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation

extension URLRequest {
    mutating func setJSONBody(_ body: Encodable) throws {
        httpBody = try JSONEncoder().encode(body)
        setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    }
    
    mutating func appendApiKey(_ apiKey: String) {
        setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    }
}
