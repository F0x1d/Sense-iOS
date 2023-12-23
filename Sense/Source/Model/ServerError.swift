//
//  ServerError.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation

struct ServerError: LocalizedError {
    let message: String
    
    var errorDescription: String? {
        message
    }
}
