//
//  SetupViewModel.swift
//  Sense
//
//  Created by Максим Зотеев on 06.07.2023.
//

import Foundation
import SwiftUI
import Factory

class SetupViewModel: BaseViewModel {
    @AppStorage("setup_done") var setupDone = false
    @AppStorage(APISettingsViewModel.API_KEY) var apiKey = APISettingsViewModel.API_KEY_DEFAULT
    
    @Published var path = NavigationPath()
    
    @Injected(\.userDefaults) private var userDefaults
    
    func saveModel(_ model: GPTModel) {
        userDefaults.set(model.apiModel, forKey: APISettingsViewModel.MODEL)
    }
}
