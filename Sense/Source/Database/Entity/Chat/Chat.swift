//
//  Chat.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import RealmSwift

class Chat: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var realmId: ObjectId
    
    @Persisted var title: String? = nil
    @Persisted var date = Date()
    @Persisted var messages = RealmSwift.List<ChatMessage>()
}
