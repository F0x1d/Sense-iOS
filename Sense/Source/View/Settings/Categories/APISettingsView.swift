//
//  APISettingsView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import Factory

struct APISettingsView: View {
    
    @InjectedObject(\.settingsStore) private var settingsStore
    
    var body: some View {
        List {
            Section("API " + String(localized: "key")) {
                ApiKeyFieldView(apiKeyText: $settingsStore.apiKey)
            }
            
            Section("models") {
                SettingsTextFieldWrapper(
                    imageSystemName: "person",
                    textFieldView: TextField("chat_model", text: $settingsStore.chatModel)
                )
                
                SettingsTextFieldWrapper(
                    imageSystemName: "pencil",
                    textFieldView: TextField("images_model", text: $settingsStore.imagesModel)
                )
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle("API")
        .navigationBarTitleDisplayMode(.inline)
    }
}
