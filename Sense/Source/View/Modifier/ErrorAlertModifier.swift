//
//  ErrorAlertModifier.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @ObservedObject var viewModel: BaseLoadViewModel
    
    func body(content: Content) -> some View {
        content
            .alert("error", isPresented: $viewModel.showingError) {
                Button("OK") {
                    viewModel.showingError = false
                }
            } message: {
                Text(viewModel.error ?? "")
            }
    }
}

extension View {
    func toastingErrors(with viewModel: BaseLoadViewModel) -> some View {
        modifier(ErrorAlertModifier(viewModel: viewModel))
    }
}
