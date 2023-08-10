//
//  SettingsTextFieldWrapper.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI

struct SettingsTextFieldWrapper: View {
    let imageSystemName: String
    let textFieldView: TextField<Text>
    var keyboardType = UIKeyboardType.default
    
    var body: some View {
        HStack {
            Image(systemName: imageSystemName)
            
            textFieldView
                .keyboardType(keyboardType)
        }
    }
}
