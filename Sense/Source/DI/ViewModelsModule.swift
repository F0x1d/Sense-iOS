//
//  ViewModelsModule.swift
//  Sense
//
//  Created by Максим Зотеев on 05.07.2023.
//

import Foundation
import Factory
import RealmSwift

@MainActor extension Container {
    
    var contentViewModel: Factory<ContentViewModel> {
        self { ContentViewModel() }
    }
    
    var setupViewModel: Factory<SetupViewModel> {
        self { SetupViewModel() }.singleton
    }
    
    var chatsViewModel: Factory<ChatsViewModel> {
        self { ChatsViewModel() }.singleton
    }
    
    var chatViewModel: ParameterFactory<ObjectId, ChatViewModel> {
        self { ChatViewModel($0) }
    }
    
    var generateViewModel: Factory<GenerateViewModel> {
        self { GenerateViewModel() }.singleton
    }
    
    var historyViewModel: Factory<HistoryViewModel> {
        self { HistoryViewModel() }.singleton
    }
    
    var historyDetailsViewModel: ParameterFactory<ObjectId, HistoryDetailsViewModel> {
        self { HistoryDetailsViewModel($0) }
    }
    
    var settingsViewModel: Factory<SettingsViewModel> {
        self { SettingsViewModel() }.singleton
    }
    
    var cacheSettingsViewModel: Factory<CacheSettingsViewModel> {
        self { CacheSettingsViewModel() }
    }
    
    var apiSettingsViewModel: Factory<APISettingsViewModel> {
        self { APISettingsViewModel() }
    }
}
