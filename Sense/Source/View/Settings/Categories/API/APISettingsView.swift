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
    
    @InjectedObject(\.apiSettingsViewModel) private var viewModel
    
    var body: some View {
        List {
            Section("API " + String(localized: "key")) {
                ApiKeyFieldView(apiKeyText: $viewModel.apiKey)
            }
            
            Section("models") {
                SettingsTextFieldWrapper(
                    imageSystemName: "person", 
                    textFieldView: TextField("chat_model", text: $viewModel.chatModel),
                    keyboardType: .default
                )
            }
            
            Section("responses") {
                SettingsTextFieldWrapper(
                    imageSystemName: "list.number", 
                    textFieldView: TextField("responses_count", value: $viewModel.responsesCount, formatter: NumberFormatter()),
                    keyboardType: .numberPad
                )
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle("API")
        .navigationBarTitleDisplayMode(.inline)
    }
}
