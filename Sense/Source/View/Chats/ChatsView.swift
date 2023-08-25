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
                    .contextMenu {
                        Button(role: .destructive) {
                            viewModel.delete(chat)
                        } label: {
                            Label("delete", systemImage: "trash")
                        }
                    }
                    .id(chat.realmId)
                }
                .onDelete { viewModel.deleteAt($0) }
                .id(ChatsViewScrollAnchor.chats)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        viewModel.create()
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
