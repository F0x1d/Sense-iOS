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
    
    static let CHAT_MODEL = "chat_model"
    static let CHAT_MODEL_DEFAULT = "gpt-3.5-turbo"
    
    static let IMAGES_MODEL = "images_model"
    static let IMAGES_MODEL_DEFAULT = "dall-e-2"
    
    @AppStorage(SETUP_DONE_KEY) var setupDone = SETUP_DONE_DEFAULT
    
    @AppStorage(API_KEY) var apiKey = API_KEY_DEFAULT
    @AppStorage(CHAT_MODEL) var chatModel = CHAT_MODEL_DEFAULT
    @AppStorage(IMAGES_MODEL) var imagesModel = IMAGES_MODEL_DEFAULT
}
