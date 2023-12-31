//
//  APIKeyTutorialView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import Factory

struct ApiKeyTutorialView: View {
    
    @InjectedObject(\.setupViewModel) private var viewModel
    
    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "key.horizontal")
                        .foregroundStyle(.red)
                    
                    Text("api_key_required")
                }
            }
            
            Section("how_to_get_it") {
                HStack {
                    Text("1.").foregroundStyle(.secondary)
                    Text("setup_step_1")
                }
                HStack {
                    Text("2.").foregroundStyle(.secondary)
                    Text("setup_step_2")
                }
                HStack {
                    Text("3.").foregroundStyle(.secondary)
                    Text("setup_step_3")
                }
                HStack {
                    Text("4.").foregroundStyle(.secondary)
                    Text("setup_step_4")
                }
                HStack {
                    Text("5.").foregroundStyle(.secondary)
                    Text("setup_step_5")
                }
            }
        }
        .overlay(alignment: .bottom) {
            FilledButton(label: "proceed") {
                viewModel.path.append(SetupScreen.apiKeyEnter)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}
