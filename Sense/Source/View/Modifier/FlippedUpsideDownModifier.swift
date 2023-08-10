//
//  FlippedUpsideDownModifier.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI

// Jetpack Compose >
struct FlippedUpsideDownModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(180))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}

extension View {
    func flippedUpsideDown() -> some View {
        self.modifier(FlippedUpsideDownModifier())
    }
}
