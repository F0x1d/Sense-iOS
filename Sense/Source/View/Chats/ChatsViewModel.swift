//
//  ChatsViewModel.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import RealmSwift
import Combine

class ChatsViewModel: BaseViewModel {
    @Published var selectedChatId: ObjectId? = nil
    
    @Published var chats = [Chat]()
        
    override init() {
        super.init()
        
        try? Realm()
            .objects(Chat.self)
            .sorted(byKeyPath: "date", ascending: false)
            .collectionPublisher
            .subscribe(on: backgroundQueue)
            .freeze()
            .map { Array($0) }
            .assertNoFailure()
            .receive(on: mainQueue)
            .assignWithAnimation(to: \.chats, on: self)
            .store(in: &cancellables)
    }
    
    func append(_ chat: Chat) {
        guard let realm = try? Realm() else { return }
        
        realm.writeAsync {
            realm.add(chat)
        } onComplete: { [weak self] error in
            self?.selectedChatId = chat.realmId
        }
    }
    
    func delete(_ chat: Chat) {
        guard let realm = try? Realm() else { return }
        guard let chat = realm.object(ofType: Chat.self, forPrimaryKey: chat.realmId) else { return }
        
        realm.writeAsync {
            realm.delete(chat)
        }
    }
    
    func deleteAt(_ indexSet: IndexSet) {
        guard let realm = try? Realm() else { return }
        
        try? realm.write {
            for index in indexSet {
                guard let chat = realm.object(ofType: Chat.self, forPrimaryKey: chats[index].realmId) else { return }
                if chat.realmId == selectedChatId {
                    selectedChatId = nil
                }
                
                realm.delete(chat)
            }
        }
    }
}
