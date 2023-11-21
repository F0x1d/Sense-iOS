//
//  SetupViewModel.swift
//  Sense
//
//  Created by Максим Зотеев on 06.07.2023.
//

import Foundation
import SwiftUI
import Factory

final class SetupViewModel: BaseViewModel {
    
    @Published var path = NavigationPath()
    
    @Published var apiKey = ""
    
    @Injected(\.settingsStore) private var settingsStore
    
    func saveModel(_ model: GPTModel) {
        settingsStore.model = model
    }
    
    func closeSetup() {
        settingsStore.apiKey = apiKey
        settingsStore.setupDone = true
    }
}
