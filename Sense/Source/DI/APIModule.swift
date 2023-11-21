//
//  APIModule.swift
//  Sense
//
//  Created by Максим Зотеев on 17.11.2023.
//

import Foundation
import Factory
import Papyrus

extension Container {
    
    var urlSession: Factory<URLSession> {
        self {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 60 * 10
            
            return URLSession(configuration: configuration)
        }
    }
    
    var gptProvider: Factory<Provider> {
        self {
            Provider(baseURL: "https://api.openai.com/v1/").modifyRequests { builder in
                builder.addAuthorization(.bearer(self.settingsStore().apiKey))
            }
        }.singleton
    }
    
    var gptAPI: Factory<GPTAPI> {
        self { GPTAPI(provider: self.gptProvider()) }
    }
}
