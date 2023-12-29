//
//  MessageView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI

struct MessageView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(
            alignment: .top,
            spacing: 0
        ) {
            Circle()
                .fill(message.fromUser ? Color.gray.opacity(0.5) : .accentColor)
                .frame(width: 20, height: 20)
                .padding(.trailing, 15)
            
            VStack(
                alignment: .leading,
                spacing: 8
            ) {
                HStack {
                    Text(message.parseRole)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                }
                
                if message.content.isEmpty {
                    ProgressView()
                } else {
                    Text(message.content)
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .contentShape(Rectangle())
    }
}
