//
//  APISettingsViewModel.swift
//  Sense
//
//  Created by Максим Зотеев on 06.07.2023.
//

import Foundation
import SwiftUI

class APISettingsViewModel: BaseViewModel {
    static let API_KEY = "api_key"
    static let API_KEY_DEFAULT = ""
    
    static let CHAT_MODEL = "chat_model"
    static let CHAT_MODEL_DEFAULT = "gpt-4"
    
    static let RESPONSES_COUNT = "responses_count"
    static let RESPONSES_COUNT_DEFAULT = 1
    
    @AppStorage(API_KEY) var apiKey = API_KEY_DEFAULT
    @AppStorage(CHAT_MODEL) var chatModel = CHAT_MODEL_DEFAULT
    @AppStorage(RESPONSES_COUNT) var responsesCount = RESPONSES_COUNT_DEFAULT
}
