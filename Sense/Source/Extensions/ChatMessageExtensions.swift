//
//  ChatMessageExtensions.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftData

extension [ChatMessage] {
    var asMessages: [Message] {
        map { $0.asMessage }
    }
    
    var asSorted: [ChatMessage] {
        sorted(by: { $0.date < $1.date })
    }
}

extension ChatMessage {
    var asMessage: Message {
        Message(role: role, content: content)
    }
    
    var fromUser: Bool {
        role == "user"
    }
    var fromChatGPT: Bool {
        role == "assistant"
    }
    
    var parseRole: String {
        if fromUser {
            return String(localized: "you")
        } else if fromChatGPT {
            return "ChatGPT"
        } else {
            return role
        }
    }
}
