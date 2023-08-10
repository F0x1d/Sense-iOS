//
//  SenseApp.swift
//  Sense
//
//  Created by Максим Зотеев on 17.06.2023.
//

import Foundation
import SwiftUI
import RealmSwift

@main
struct SenseApp: SwiftUI.App {
    
    init() {
        let config = Realm.Configuration(schemaVersion: 3)
        Realm.Configuration.defaultConfiguration = config
        
        Task { @MainActor in
            try? await Realm().markAsNotGenerating()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
