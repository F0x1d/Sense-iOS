//
//  ChatView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import RealmSwift
import AlertKit
import Factory

struct ChatView: View {
    
    @StateObject private var viewModel: ChatViewModel
        
    init(id: ObjectId) {
        _viewModel = StateObject(wrappedValue: Container.shared.chatViewModel(id))
    }
        
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                let messages = viewModel.chat?.messages ?? List<ChatMessage>()
                
                if !messages.isEmpty { Divider() }
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(messages) { message in
                            MessageView(
                                message: message,
                                index: messages.firstIndex(of: message)!,
                                messagesCount: messages.count,
                                actions: viewModel.messageActions
                            )
                            .id(message.realmId)
                        }
                        .flippedUpsideDown()
                    }
                    .animation(.spring(), value: messages.count) // Avoiding animation on text changes during generation
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
                    
                    SendButton(enabled: !viewModel.generating) {
                        sendMessage()
                    }
                    .padding(.vertical, 7)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
        }
        .toastingErrors(with: viewModel)
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(viewModel.chat?.title ?? "")
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
