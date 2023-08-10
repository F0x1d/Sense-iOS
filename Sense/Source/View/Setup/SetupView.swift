//
//  SetupView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import Factory

struct SetupView: View {
    
    @InjectedObject(\.setupViewModel) private var viewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack {
                Spacer()
                
                Image("OpenAILogo")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                    .padding()
                
                Text("welcome")
                    .font(.title)
                    .bold()
                
                Text("welcome_summary")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(1)
                
                Spacer()
                
                FilledButton(label: "hi") {
                    viewModel.path.append(SetupScreen.apiKeyTutorial)
                }
                .padding()
            }
            .navigationDestination(for: SetupScreen.self) { screen in 
                switch (screen) {
                case .apiKeyTutorial:
                    ApiKeyTutorialView()
                case .apiKeyEnter:
                    ApiKeyEnterView()
                }
            }
        }
    }
}
