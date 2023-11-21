//
//  ChatView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import SwiftData
import AlertKit
import Factory

struct ChatView: View {
    
    @StateObject private var viewModel: ChatViewModel
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var messages: [ChatMessage]
    @Query private var generatingMessages: [ChatMessage]
    
    @State private var scrolledToBottom = false
        
    init(chat: Chat) {
        _viewModel = StateObject(wrappedValue: Container.shared.chatViewModel(chat))
        
        let chatId = chat.persistentModelID
        _messages = Query(
            filter: #Predicate {
                $0.chat?.persistentModelID == chatId
            }, 
            sort: \.date,
            animation: .spring
        )
        _generatingMessages = Query(
            filter: #Predicate { 
                $0.generating && $0.chat?.persistentModelID == chatId
            }
        )
    }
        
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                List {
                    ForEach(messages) { message in
                        MessageView(message: message)
                            .contextMenu {
                                Button {
                                    UIPasteboard.general.string = message.content
                                    AlertKitAPI.present(title: String(localized: "copied"), icon: .done, style: .iOS17AppleMusic, haptic: .success)
                                } label: {
                                    Label("copy", systemImage: "doc.on.doc")
                                }
                                
                                ShareLink(item: message.content) {
                                    Label("share", systemImage: "square.and.arrow.up")
                                }
                                
                                Button(role: .destructive) {
                                    modelContext.delete(message)
                                } label: {
                                    Label("delete", systemImage: "trash")
                                }
                            }
                            .padding(.vertical, 5)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .id(message)
                    }
                }
                .onAppear {
                    if (!scrolledToBottom) {
                        proxy.scrollTo(messages.last, anchor: .bottom)
                        scrolledToBottom = true
                    }
                }
                .onChange(of: messages.last?.content, initial: false) { old, new in
                    proxy.scrollTo(messages.last, anchor: .bottom)
                }
                .listStyle(.plain)
            }
            
            if !messages.isEmpty { Divider() }
            
            HStack(alignment: .bottom) {
                TextField("message", text: $viewModel.text, axis: .vertical)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .onSubmit {
                        sendMessage()
                    }
                
                SendButton(enabled: generatingMessages.isEmpty) {
                    sendMessage()
                }
                .animation(.default, value: generatingMessages.count)
                .padding(.vertical, 7)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .toastingErrors(with: viewModel)
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(viewModel.chat.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sendMessage() {
        viewModel.text = viewModel.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if viewModel.text.isEmpty {
            return
        }
        
        viewModel.startLoading()
    }
}
