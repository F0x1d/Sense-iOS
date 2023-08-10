//
//  MessageView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import RealmSwift

struct MessageView: View {
    let message: ChatMessage
    let index: Int
    let messagesCount: Int
    let actions: [MessageAction]
    
    @State private var expanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if message.fromUser {
                    Spacer()
                }
                
                Text(message.parseRole)
                    .font(.caption)
                    .foregroundColor(.secondary)
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
                
                Text(message.content)
                    .foregroundColor(message.fromUser ? .white : .primary)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(message.fromUser ? .blue : Color(.secondarySystemBackground))
                    .clipShape(RoundedCorners(
                        tl: 20,
                        tr: 20,
                        bl: message.fromChatGPT ? 5 : 20,
                        br: message.fromUser ? 5 : 20
                    ))
                
                if message.fromChatGPT {
                    Spacer()
                }
            }
            .padding(.horizontal, 7)
            
            if expanded && !actions.isEmpty {
                HStack {
                    if message.fromUser {
                        Spacer()
                    }
                    
                    ForEach(actions) { action in
                        if action.type == "share" {
                            ShareLink(item: message.content) {
                                Label(action.title, systemImage: action.icon)
                                    .frame(height: 25)
                            }
                            .foregroundColor(action.tint)
                            .buttonStyle(.bordered)
                            .cornerRadius(10)
                        } else {
                            Button {
                                if action.onClick?(message) ?? false {
                                    withAnimation(.spring()) {
                                        expanded = false
                                    }
                                }
                            } label: {
                                Label(action.title, systemImage: action.icon)
                                    .frame(height: 25)
                            }
                            .foregroundColor(action.tint)
                            .buttonStyle(.bordered)
                            .cornerRadius(10)
                        }
                    }
                    
                    if message.fromChatGPT {
                        Spacer()
                    }
                }
                .padding(.horizontal, 7)
                .padding(.top, 7)
            }
        }
        .padding(.bottom, index == 0 ? 10 : 5)
        .padding(.top, index + 1 == messagesCount ? 10 : 5)
        .onTapGesture {
            withAnimation(.spring()) {
                expanded.toggle()
            }
        }
    }
}
