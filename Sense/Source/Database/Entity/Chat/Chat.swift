//
//  Chat.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftData

@Model
class Chat {
    var title: String? = nil
    var date = Date()
    
    @Relationship(
        deleteRule: .cascade,
        inverse: \ChatMessage.chat
    ) var messages = [ChatMessage]()
    
    init(title: String? = nil, date: Date = Date()) {
        self.title = title
        self.date = date
    }
}
