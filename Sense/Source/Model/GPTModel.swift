//
//  GPTModel.swift
//  Sense
//
//  Created by Максим Зотеев on 16.08.2023.
//

import Foundation

enum GPTModel: String, Identifiable, CaseIterable {
    
    var id: Self {
        return self
    }
    
    case gpt3_5
    case gpt3_5_16k
    
    case gpt4
    case gpt4_32k
    
    var name: String {
        switch self {
        case .gpt3_5:
            return "GPT 3.5"
        case .gpt3_5_16k:
            return "GPT 3.5, 16K"
            
        case .gpt4:
            return "GPT 4"
        case .gpt4_32k:
            return "GPT 4, 32K"
        }
    }
    
    var descriptionKey: String {
        switch self {
        case .gpt3_5:
            return "gpt-3.5-desc"
        case .gpt3_5_16k:
            return "gpt-3.5-16k-desc"
            
        case .gpt4:
            return "gpt-4-desc"
        case .gpt4_32k:
            return "gpt-4-32k-desc"
        }
    }
    
    var apiModel: String {
        switch self {
        case .gpt3_5:
            return "gpt-3.5-turbo"
        case .gpt3_5_16k:
            return "gpt-3.5-turbo-16k"
            
        case .gpt4:
            return "gpt-4"
        case .gpt4_32k:
            return "gpt-4-32k"
        }
    }
}
