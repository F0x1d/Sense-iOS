//
//  ChatMessage.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import RealmSwift

class ChatMessage: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var realmId: ObjectId
    
    @Persisted var role: String
    @Persisted var content: String
    @Persisted var date = Date()
    @Persisted var generating = false
    
    @Persisted(originProperty: "messages") var assignee: LinkingObjects<Chat>
}
