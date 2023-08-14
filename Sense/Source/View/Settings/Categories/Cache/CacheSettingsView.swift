//
//  CacheSettingsView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import Factory

struct CacheSettingsView: View {
    
    @InjectedObject(\.cacheSettingsViewModel) private var viewModel
        
    var body: some View {
        List {
            Section("image_cache") {
                Text(String((Double(viewModel.cacheSize) / 1024 / 1024).rounded(3)) + " MB")
                
                Button {
                    viewModel.clearCache()
                } label: {
                    Label("clear", systemImage: "trash")
                }
                .foregroundStyle(.red)
            }
        }
        .onAppear {
            viewModel.updateCacheSize()
        }
        .navigationTitle("cache")
        .navigationBarTitleDisplayMode(.inline)
    }
}
