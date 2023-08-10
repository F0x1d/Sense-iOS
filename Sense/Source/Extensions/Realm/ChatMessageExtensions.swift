//
//  ChatMessageExtensions.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import RealmSwift

extension RealmSwift.List<ChatMessage> {
    var asMessages: [Message] {
        map { $0.asMessage }
    }
    
    func insertMessage(_ message: ChatMessage) {
        insert(message, at: startIndex)
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
