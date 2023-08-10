//
//  GenerateMessageResponse.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation

struct GenerateMessageResponse: Decodable {
    let choices: [MessageChoice]
    
    struct MessageChoice: Decodable {
        let message: Message?
        let delta: Delta?
        let index: Int?
        
        struct Delta: Decodable {
            let role: String?
            let content: String?
        }
    }
}
