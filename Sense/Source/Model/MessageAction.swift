//
//  MessageAction.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI

struct MessageAction: Identifiable {
    let title: String
    let icon: String
    var type: String = "default"
    var onClick: ((ChatMessage) -> Bool)? = nil
    var tint: Color = .accentColor
    
    var id: String {
        return self.title + self.icon + self.type
    }
}
