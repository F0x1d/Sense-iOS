//
//  DatabaseModule.swift
//  Sense
//
//  Created by Максим Зотеев on 21.10.2023.
//

import Foundation
import Factory
import SwiftData

extension Container {
    var modelContainer: Factory<ModelContainer> {
        self { try! ModelContainer(for: Chat.self, ChatMessage.self, GeneratedImage.self) }.singleton
    }
    
    @MainActor var modelContext: Factory<ModelContext> {
        self { self.modelContainer().mainContext }
    }
}
