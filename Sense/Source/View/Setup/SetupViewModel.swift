//
//  SetupViewModel.swift
//  Sense
//
//  Created by Максим Зотеев on 06.07.2023.
//

import Foundation
import SwiftUI

class SetupViewModel: BaseViewModel {
    @AppStorage("setup_done") var setupDone = false
    @AppStorage(APISettingsViewModel.API_KEY) var apiKey = APISettingsViewModel.API_KEY_DEFAULT
    
    @Published var path = NavigationPath()
}
