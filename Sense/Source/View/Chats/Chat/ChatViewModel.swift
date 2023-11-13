//
//  ChatViewModel.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import SwiftData
import Factory

class ChatViewModel: BaseLoadViewModel {
    let chat: Chat
    
    @Published var text = ""
    @Published var generating = false
            
    @Injected(\.gptRepository) private var gptRepository
    @Injected(\.userDefaults) private var userDefaults
    @Injected(\.modelContext) private var modelContext
    
    init(_ chat: Chat) {
        self.chat = chat
    }
    
    override func provideData() async throws {
        let userMessage = ChatMessage(role: "user", content: text)
        
        if chat.messages.isEmpty {
            chat.title = text
        }
        
        chat.messages.append(userMessage)
        chat.date = .now
        
        text = ""
        
        let currentChatMessages = chat.messages
        let sortChatMessagesTask = Task { @RepositoryActor in
            currentChatMessages.asSorted.asMessages
        }
        
        let responseMessage = ChatMessage(role: "assistant", content: "", generating: true)
        
        chat.messages.append(responseMessage)
        chat.date = .now
                                
        let selectedModel = GPTModel(rawValue: userDefaults.string(forKey: APISettingsViewModel.MODEL) ?? "")
        try await gptRepository.generateMessage(
            model: selectedModel ?? APISettingsViewModel.MODEL_DEFAULT,
            messages: await sortChatMessagesTask.value,
            apiKey: userDefaults.string(forKey: APISettingsViewModel.API_KEY) ?? APISettingsViewModel.API_KEY_DEFAULT
        ) { (content, cancelled) in
            if responseMessage.isDeleted {
                cancelled = true
                return
            }
            
            responseMessage.content = content.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        responseMessage.generating = false
        chat.date = .now
    }
    
    override func handleError(_ error: Error) async {
        var descriptor = FetchDescriptor<ChatMessage>()
        
        let chatId = chat.persistentModelID
        descriptor.predicate = #Predicate {
            $0.generating && $0.chat?.persistentModelID == chatId
        }
        
        guard let generatingMessages = try? modelContext.fetch(descriptor) else { return }
        
        let newMessageContent = String(format: String(localized: "in_message_error"), arguments: [error.localizedDescription])
        for message in generatingMessages {
            message.content = newMessageContent
            message.generating = false
        }
    }
}
