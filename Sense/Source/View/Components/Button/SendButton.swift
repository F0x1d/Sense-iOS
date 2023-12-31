//
//  SendButton.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI

struct SendButton: View {
    var loading: Bool = false
    var enabled: Bool = true
    
    let onClick: () -> Void
    
    var body: some View {
        if loading {
            ProgressView()
                .frame(width: 22, height: 22)
        } else {
            Image(systemName: "arrow.up.forward.circle.fill")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundStyle(.tint)
                .onTapGesture(perform: onClick)
                .keyboardShortcut(.return)
                .onSubmit(onClick)
                .disabled(!enabled)
        }
    }
}
