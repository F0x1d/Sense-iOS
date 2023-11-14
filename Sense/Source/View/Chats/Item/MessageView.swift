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
        VStack(spacing: 0) {
            HStack {
                if message.fromUser {
                    Spacer()
                }
                
                Text(message.parseRole)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 19)
                
                if message.fromChatGPT {
                    Spacer()
                }
            }
            Spacer()
                .frame(height: 4)
            
            HStack {
                if message.fromUser {
                    Spacer()
                }
                
                if message.content.isEmpty {
                    ProgressView()
                        .asMessage(with: message)
                } else {
                    Text(message.content)
                        .foregroundStyle(message.fromUser ? .white : .primary)
                        .asMessage(with: message)
                }
                
                if message.fromChatGPT {
                    Spacer()
                }
            }
            .padding(.horizontal, 7)
        }
    }
}

fileprivate extension View {
    func asMessage(with message: ChatMessage) -> some View {
        self
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(message.fromUser ? .blue : Color(.secondarySystemBackground))
            .clipShape(RoundedCorners(
                tl: 20,
                tr: 20,
                bl: message.fromChatGPT ? 5 : 20,
                br: message.fromUser ? 5 : 20
            ))
    }
}
