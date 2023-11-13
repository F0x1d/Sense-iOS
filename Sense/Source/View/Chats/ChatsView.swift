//
//  ChatsView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import Factory
import SwiftData

struct ChatsView: View {
        
    @InjectedObject(\.chatsViewModel) private var viewModel
    
    @Environment(\.modelContext) private var modelContext
        
    @Query(
        sort: \Chat.date,
        order: .reverse,
        animation: .spring
    ) private var chats: [Chat]
    
    var body: some View {
        NavigationSplitView {
            List(selection: $viewModel.selectedChat) {
                ForEach(chats) { chat in
                    NavigationLink(value: chat) {
                        ChatItemView(chat: chat)
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            modelContext.delete(chat)
                        } label: {
                            Label("delete", systemImage: "trash")
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(chats[index])
                    }
                }
                .id(ChatsViewScrollAnchor.chats)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        let chat = Chat()
                        modelContext.insert(chat)
                        
                        viewModel.selectedChat = chat
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("chats")
        } detail: {
            if let chat = viewModel.selectedChat {
                ChatView(chat: chat)
                    .id(chat.id)
            } else {
                Text("select_chat")
                    .font(.title)
                    .bold()
                    .navigationTitle("")
            }
        }
    }
}

enum ChatsViewScrollAnchor {
    case chats
}
