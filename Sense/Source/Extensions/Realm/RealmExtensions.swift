//
//  RealmExtensions.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import RealmSwift

@MainActor extension Realm {
    func markAsNotGenerating() async {
        let messages = objects(ChatMessage.self).where {
            $0.generating
        }
        
        await updateMessages(messages)
    }
    
    func markAsNotGeneratingIn(chatId: ObjectId) async {
        let messages = objects(ChatMessage.self).where {
            $0.generating && $0.assignee.realmId == chatId
        }
        
        await updateMessages(messages)
    }
    
    private func updateMessages(_ messages: Results<ChatMessage>) async {
        try? await asyncWrite {
            for message in messages {
                message.generating = false
            }
        }
    }
}
