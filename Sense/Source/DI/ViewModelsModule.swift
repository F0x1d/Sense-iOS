//
//  ViewModelsModule.swift
//  Sense
//
//  Created by Максим Зотеев on 05.07.2023.
//

import Foundation
import Factory
import SwiftData

@MainActor extension Container {
    
    var contentViewModel: Factory<ContentViewModel> {
        self { ContentViewModel() }
    }
    
    var setupViewModel: Factory<SetupViewModel> {
        self { SetupViewModel() }.scope(.shared)
    }
    
    var chatsViewModel: Factory<ChatsViewModel> {
        self { ChatsViewModel() }.scope(.shared)
    }
    
    var chatViewModel: ParameterFactory<Chat, ChatViewModel> {
        self { ChatViewModel($0) }
    }
    
    var generateViewModel: Factory<GenerateViewModel> {
        self { GenerateViewModel() }.scope(.shared)
    }
    
    var historyViewModel: Factory<HistoryViewModel> {
        self { HistoryViewModel() }.scope(.shared)
    }
    
    var historyDetailsViewModel: ParameterFactory<GeneratedImage, HistoryDetailsViewModel> {
        self { HistoryDetailsViewModel($0) }
    }
    
    var settingsViewModel: Factory<SettingsViewModel> {
        self { SettingsViewModel() }.scope(.shared)
    }
    
    var cacheSettingsViewModel: Factory<CacheSettingsViewModel> {
        self { CacheSettingsViewModel() }
    }
}
