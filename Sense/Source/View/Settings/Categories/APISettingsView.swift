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
            
            Picker(selection: $settingsStore.model) {
                ForEach(GPTModel.allCases) { model in
                    GPTModelView(model: model)
                }
            } label: {
                Text("chat_model")
            }
            .pickerStyle(.inline)
            
            Section("responses") {
                SettingsTextFieldWrapper(
                    imageSystemName: "list.number", 
                    textFieldView: TextField("responses_count", value: $settingsStore.responsesCount, formatter: NumberFormatter()),
                    keyboardType: .numberPad
                )
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .navigationTitle("API")
        .navigationBarTitleDisplayMode(.inline)
    }
}