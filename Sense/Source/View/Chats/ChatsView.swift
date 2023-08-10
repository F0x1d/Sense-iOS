//
//  ChatsView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import Factory

struct ChatsView: View {
        
    @InjectedObject(\.chatsViewModel) private var viewModel
    
    var body: some View {
        NavigationSplitView {
            List(selection: $viewModel.selectedChatId) {
                ForEach(viewModel.chats) { chat in
                    NavigationLink(value: chat.realmId) {
                        if let content = chat.messages.first?.content {
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
                    .id(chat.realmId)
                }
                .onDelete { viewModel.delete($0) }
                .id(ChatsViewScrollAnchor.chats)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        let chat = Chat()
                        viewModel.append(chat)
                        
                        viewModel.selectedChatId = chat.realmId
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("chats")
        } detail: {
            if let chatId = viewModel.selectedChatId {
                ChatView(id: chatId)
                    .id(chatId)
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
