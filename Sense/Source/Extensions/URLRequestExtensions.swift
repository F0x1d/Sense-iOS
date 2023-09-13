//
//  URLRequestExtensions.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation

extension URLRequest {
    mutating func appendApiKey(_ apiKey: String) {
        setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    }
}
