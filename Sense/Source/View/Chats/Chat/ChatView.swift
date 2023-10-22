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
        
    init(chat: Chat) {
        _viewModel = StateObject(wrappedValue: Container.shared.chatViewModel(chat))
        
        let chatId = chat.persistentModelID
        _messages = Query(
            filter: #Predicate {
                $0.chat?.persistentModelID == chatId
            }, 
            sort: \.date,
            order: .reverse,
            animation: .spring
        )
        _generatingMessages = Query(
            filter: #Predicate { 
                $0.generating && $0.chat?.persistentModelID == chatId
            }
        )
    }
        
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if !messages.isEmpty { Divider() }
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(messages) { message in
                            let index = messages.firstIndex(of: message) ?? 0
                            
                            MessageView(
                                message: message,
                                actions: viewModel.messageActions
                            )
                            .padding(.bottom, index == 0 ? 10 : 5)
                            .padding(.top, index + 1 == messages.count ? 10 : 5)
                            .id(message.id)
                        }
                        .flippedUpsideDown()
                    }
                }
                .flippedUpsideDown()
                
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
                    
                    SendButton(enabled: generatingMessages.count == 0) {
                        sendMessage()
                    }
                    .animation(.default, value: generatingMessages.count)
                    .padding(.vertical, 7)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
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
