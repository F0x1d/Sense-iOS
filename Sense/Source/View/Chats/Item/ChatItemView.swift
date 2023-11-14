//
//  ChatItemView.swift
//  Sense
//
//  Created by Максим Зотеев on 12.11.2023.
//

import Foundation
import SwiftUI
import SwiftData

struct ChatItemView: View {
    let chat: Chat
    
    @Query private var messages: [ChatMessage]
    
    init(chat: Chat) {
        self.chat = chat
        
        let chatId = chat.persistentModelID
        _messages = Query(
            filter: #Predicate {
                $0.chat?.persistentModelID == chatId
            },
            sort: \.date
        )
    }
    
    var body: some View {
        if let content = messages.last?.content {
            VStack(alignment: .leading) {
                Text(chat.title ?? "")
                    .lineLimit(1)
                    .font(.title3)
                    .bold()
                
                Spacer()
                    .frame(height: 5)
                
                Text(content)
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
            }
        } else {
            Text("nothing_there")
                .foregroundStyle(.secondary)
        }
    }
}
