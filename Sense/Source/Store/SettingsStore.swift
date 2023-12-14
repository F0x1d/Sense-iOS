//
//  SettingsStore.swift
//  Sense
//
//  Created by Максим Зотеев on 14.11.2023.
//

import Foundation
import SwiftUI

final class SettingsStore: BaseStore {
    
    static let SETUP_DONE_KEY = "setup_done"
    static let SETUP_DONE_DEFAULT = false
    
    static let API_KEY = "api_key"
    static let API_KEY_DEFAULT = ""
    
    static let MODEL = "model"
    static let MODEL_DEFAULT = "gpt-3.5"
    
    static let RESPONSES_COUNT = "responses_count"
    static let RESPONSES_COUNT_DEFAULT = 1
    
    @AppStorage(SETUP_DONE_KEY) var setupDone = SETUP_DONE_DEFAULT
    
    @AppStorage(API_KEY) var apiKey = API_KEY_DEFAULT
    @AppStorage(MODEL) var model = MODEL_DEFAULT
    @AppStorage(RESPONSES_COUNT) var responsesCount = RESPONSES_COUNT_DEFAULT
}
