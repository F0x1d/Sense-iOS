//
//  SenseApp.swift
//  Sense
//
//  Created by Максим Зотеев on 17.06.2023.
//

import Foundation
import SwiftUI
import SwiftData
import Factory

@main
struct SenseApp: SwiftUI.App {
    
    @Injected(\.modelContainer) private var modelContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
