//
//  SetupModelView.swift
//  Sense
//
//  Created by Максим Зотеев on 16.08.2023.
//

import Foundation
import SwiftUI
import Factory

struct SetupModelView: View {
    
    @InjectedObject(\.setupViewModel) private var viewModel
    
    @State private var selectedModel = GPTModel.gpt3_5
    
    var body: some View {
        List {
            Picker(selection: $selectedModel) {
                ForEach(GPTModel.allCases) { model in
                    GPTModelView(model: model)
                }
            } label: {
                Text("select_model")
            }
            .pickerStyle(.inline)
        }
        .overlay(alignment: .bottom) {
            FilledButton(label: "proceed") {
                viewModel.saveModel(selectedModel)
                viewModel.path.append(SetupScreen.apiKeyTutorial)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}
