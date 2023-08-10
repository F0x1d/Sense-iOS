//
//  GenerateMessageRequestBody.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation

struct GenerateMessageRequestBody: Encodable {
    let messages: [Message]
    let model: String
    let stream = true
}
