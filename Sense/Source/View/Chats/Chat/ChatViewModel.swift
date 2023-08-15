//
//  ChatViewModel.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import RealmSwift
import Factory
import Combine
import AlertKit

class ChatViewModel: BaseLoadViewModel {
    let id: ObjectId
    @Published var chat: Chat? = nil
    
    @Published var text = ""
    @Published var generating = false
    
    lazy var messageActions = [
        MessageAction(
            title: String(localized: "copy"),
            icon: "doc.on.doc",
            onClick: { message in
                UIPasteboard.general.string = message.content
                AlertKitAPI.present(title: String(localized: "copied"), icon: .done, style: .iOS17AppleMusic, haptic: .success)
                return true
            }
        ),
        MessageAction(
            title: String(localized: "share"),
            icon: "square.and.arrow.up",
            type: "share"
        ),
        MessageAction(
            title: String(localized: "delete"),
            icon: "trash",
            onClick: { [weak self] message in self?.delete(message: message) ?? false },
            tint: .red
        )
    ]
        
    @Injected(\.gptRepository) private var gptRepository
    @Injected(\.userDefaults) private var userDefaults
    
    init(_ id: ObjectId) {
        self.id = id
        super.init()
        
        guard let realm = try? Realm() else { return }
        
        realm
            .objects(Chat.self)
            .where { $0.realmId == id }
            .collectionPublisher
            .subscribe(on: backgroundQueue)
            .freeze()
            .map { $0.first }
            .removeDuplicates()
            .assertNoFailure()
            .receive(on: mainQueue)
            .assign(to: \.chat, on: self)
            .store(in: &cancellables)
            
                
        realm
            .objects(ChatMessage.self)
            .where { $0.generating && $0.assignee.realmId == id }
            .collectionPublisher
            .subscribe(on: backgroundQueue)
            .freeze()
            .map {
                $0.contains {
                    $0.generating
                }
            }
            .removeDuplicates()
            .assertNoFailure()
            .receive(on: mainQueue)
            .assignWithAnimation(to: \.generating, on: self)
            .store(in: &cancellables)
    }
    
    override func provideData() async throws {
        let realm = try await Realm()
        
        guard let chat = chat?.thaw() else { return }
                
        let userMessage = ChatMessage()
        userMessage.role = "user"
        userMessage.content = text
        
        try await realm.asyncWrite {
            if chat.title == nil {
                chat.title = text
            }
            
            chat.messages.insertMessage(userMessage)
            chat.date = .now
        }
                
        text = ""
        
        let responseMessage = ChatMessage()
        responseMessage.role = "assistant"
        responseMessage.content = ""
        responseMessage.generating = true
        
        var addedMessage = false
        
        let selectedModel = GPTModel(rawValue: userDefaults.string(forKey: APISettingsViewModel.MODEL) ?? "")
        try await gptRepository.generateMessage(
            model: (selectedModel ?? APISettingsViewModel.MODEL_DEFAULT).apiModel,
            messages: chat.messages.asMessages.reversed(),
            apiKey: userDefaults.string(forKey: APISettingsViewModel.API_KEY) ?? APISettingsViewModel.API_KEY_DEFAULT
        ) { (content, cancelled) in
            if responseMessage.isInvalidated {
                cancelled = true
                return
            }
            
            if !addedMessage {
                responseMessage.content = content
                
                try await realm.asyncWrite {
                    chat.messages.insertMessage(responseMessage)
                    chat.date = .now
                }
                addedMessage = true
            } else {
                try await realm.asyncWrite {
                    responseMessage.content = content.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        }
        
        if responseMessage.isInvalidated { return }
        
        try await realm.asyncWrite {
            responseMessage.generating = false
            chat.date = .now
        }
    }
    
    override func handleError(_ error: Error) async {
        try? await Realm().markAsNotGeneratingIn(chatId: id)
    }
    
    func delete(message: ChatMessage) -> Bool {
        guard let realm = try? Realm() else { return false }
        guard let message = realm.object(ofType: ChatMessage.self, forPrimaryKey: message.realmId) else { return false }
        
        realm.writeAsync {
            realm.delete(message)
        }
        return true
    }
}
