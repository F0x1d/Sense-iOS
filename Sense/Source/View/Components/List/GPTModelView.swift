//
//  GPTModelView.swift
//  Sense
//
//  Created by Максим Зотеев on 16.08.2023.
//

import Foundation
import SwiftUI

struct GPTModelView: View {
    let model: GPTModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(model.name)
            Text(LocalizedStringKey(model.descriptionKey))
                .foregroundStyle(.secondary)
        }
        .tag(model)
    }
}
