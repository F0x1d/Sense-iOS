//
//  ApiKeyFieldView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI

struct ApiKeyFieldView: View {
    @Binding var apiKeyText: String
    
    var body: some View {
        SettingsTextFieldWrapper(
            imageSystemName: "key.horizontal", 
            textFieldView: TextField("key", text: $apiKeyText)
        )
    }
}
