//
//  SettingsView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import Factory

struct SettingsView: View {
    
    @InjectedObject(\.settingsViewModel) private var viewModel
    
    var body: some View {
        NavigationSplitView {
            List(selection: $viewModel.selectedScreen) {
                NavigationLink(value: SettingsScreen.api) {
                    Label("API", systemImage: "server.rack")
                }
                .id(SettingsViewScrollAnchor.items)
                /*NavigationLink(value: SettingsScreen.ui) {
                    Label("UI", systemImage: "swatchpalette")
                }*/
                NavigationLink(value: SettingsScreen.cache) {
                    Label("cache", systemImage: "internaldrive")
                }
                
                Section("Sense") {
                    NavigationLink(value: SettingsScreen.about) {
                        Label("about_app", systemImage: "applescript")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("settings")
        } detail: {
            switch (viewModel.selectedScreen) {
            case .api:
                APISettingsView()
            case .ui:
                UISettingsView()
            case .cache:
                CacheSettingsView()
            case .about:
                AboutAppView()
                
            default: 
                EmptyView()
            }
        }
    }
}

enum SettingsViewScrollAnchor {
    case items
}
