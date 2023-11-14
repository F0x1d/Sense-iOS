//
//  APIKeyEnterView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import Factory

struct ApiKeyEnterView: View {
    
    @InjectedObject(\.setupViewModel) private var viewModel
    
    var body: some View {
        List {
            Button {
                viewModel.path.removeLast()
            } label: {
                Label("instruction", systemImage: "arrow.backward")
            }
            
            Section("API " + String(localized: "key")) {
                ApiKeyFieldView(apiKeyText: $viewModel.apiKey)
            }
            
            Section("what_for") {
                Text("what_for_answer")
            }
        }
        .overlay(alignment: .bottom) {
            if !viewModel.apiKey.isEmpty {
                FilledButton(label: "done") {
                    withAnimation {
                        viewModel.closeSetup()
                    }
                }
                .padding()
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .navigationBarBackButtonHidden(true)
    }
}
