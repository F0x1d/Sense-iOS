//
//  ChatMessage.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftData

@Model
class ChatMessage {
    var role: String
    var content: String
    var date = Date()
    var generating = false
    
    var chat: Chat?
    
    init(role: String, content: String, date: Date = Date(), generating: Bool = false) {
        self.role = role
        self.content = content
        self.date = date
        self.generating = generating
    }
}
