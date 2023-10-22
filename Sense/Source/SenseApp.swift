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
    
    @State private var modelContainer = Container.shared.modelContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}
