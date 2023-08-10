//
//  AboutAppView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI

struct AboutAppView: View {
    var body: some View {
        List {
            Section("releases") {
                Link("Telegram", destination: URL(string: "https://t.me/f0x1dsshit")!)
            }
            
            Section("developer") {
                Link("F0x1d", destination: URL(string: "https://t.me/f0x1d")!)
            }
            
            Section("inspiration") {
                Link("mi11ion", destination: URL(string: "https://t.me/mi11ione")!)
            }
        }
        .navigationTitle("about_app")
        .navigationBarTitleDisplayMode(.inline)
    }
}
