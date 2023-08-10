//
//  GenerateView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import Factory

struct GenerateView: View {
            
    @InjectedObject(\.generateViewModel) private var viewModel
    
    @FocusState private var isEditing
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(alignment: .bottom) {
                        TextField("generation_example", text: $viewModel.prompt)
                            .disabled(viewModel.loading)
                            .focused($isEditing)
                            .submitLabel(.go)
                            .onSubmit {
                                generate()
                            }
                        
                        SendButton(loading: viewModel.loading) {
                            generate()
                        }
                    }
                }
                .id(GenerateViewScrollAnchor.prompt)
                
                if let data = viewModel.data {
                    Section("response") {
                        ForEach(data) { url in
                            ListAsyncImage(url: url)
                        }
                    }
                }
            }
            .toastingErrors(with: viewModel)
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle("generate_image")
        }
    }
    
    private func generate() {
        viewModel.prompt = viewModel.prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        
        isEditing = false
        if viewModel.prompt.isEmpty { 
            withAnimation {
                viewModel.data = nil
            }
            return
        }
        
        viewModel.startLoading()
    }
}

enum GenerateViewScrollAnchor {
    case prompt
}
