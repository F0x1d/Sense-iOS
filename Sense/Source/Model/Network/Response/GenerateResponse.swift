//
//  GenerateResponse.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation

struct GenerateResponse: Decodable {
    let choices: [Choice]
    
    struct Choice: Decodable {
        let text: String
    }
}
