//
//  ContentView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import Factory

struct ContentView: View {
    
    @InjectedObject(\.contentViewModel) private var viewModel
    
    @InjectedObject(\.setupViewModel) private var setupViewModel
    @InjectedObject(\.chatsViewModel) private var chatsViewModel
    @InjectedObject(\.generateViewModel) private var generateViewModel
    @InjectedObject(\.historyViewModel) private var historyViewModel
    @InjectedObject(\.settingsViewModel) private var settingsViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            if (!setupViewModel.setupDone) {
                SetupView()
            } else {
                TabView(selection: createTabViewBinding(scrollViewProxy: proxy)) {
                    ChatsView()
                        .tag(ContentViewTab.chat)
                        .tabItem {
                            Label("chats", systemImage: "person.and.background.dotted")
                        }
                    
                    GenerateView()
                        .tag(ContentViewTab.generateImage)
                        .tabItem { 
                            Label("image", systemImage: "timelapse")
                        }
                    
                    HistoryView()
                        .tag(ContentViewTab.history)
                        .tabItem {
                            Label("history", systemImage: "square.3.layers.3d.down.right")
                        }
                    
                    SettingsView()
                        .tag(ContentViewTab.settings)
                        .tabItem { 
                            Label("settings", systemImage: "wand.and.stars")
                        }
                }
            }
        }
    }
    
    private func createTabViewBinding(scrollViewProxy: ScrollViewProxy) -> Binding<ContentViewTab> {
        Binding<ContentViewTab>(
            get: { viewModel.selectedTab },
            set: { selectedTab in
                withAnimation {
                    if selectedTab == viewModel.selectedTab {
                        switch (selectedTab) {
                        case .chat:
                            if chatsViewModel.selectedChat != nil {
                                chatsViewModel.selectedChat = nil
                            } else {
                                scrollViewProxy.scrollTo(ChatsViewScrollAnchor.chats, anchor: .bottom)
                            }
                            
                        case .generateImage:
                            if generateViewModel.data != nil {
                                generateViewModel.data = nil
                            } else {
                                scrollViewProxy.scrollTo(GenerateViewScrollAnchor.prompt, anchor: .bottom)
                            }
                            
                        case .history:
                            if historyViewModel.selectedImage != nil {
                                historyViewModel.selectedImage = nil
                            } else {
                                scrollViewProxy.scrollTo(HistoryViewScrollAnchor.items, anchor: .bottom)
                            }
                            
                        case .settings:
                            if settingsViewModel.selectedScreen != nil {
                                settingsViewModel.selectedScreen = nil
                            } else {
                                scrollViewProxy.scrollTo(SettingsViewScrollAnchor.items, anchor: .bottom)
                            }
                        }
                    }
                    
                    viewModel.selectedTab = selectedTab
                }
            }
        )
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
