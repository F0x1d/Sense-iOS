//
//  GeneratedImage.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import RealmSwift

class GeneratedImage: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var realmId: ObjectId
    
    @Persisted var prompt: String
    @Persisted var urls = RealmSwift.List<String>()
    @Persisted var date = Date()
}
