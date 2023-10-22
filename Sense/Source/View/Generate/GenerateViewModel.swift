//
//  GenerateViewModel.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import SwiftData
import Factory

class GenerateViewModel: BaseDataLoadingViewModel<[String]> {
    
    @Published var prompt = ""
    
    @Injected(\.gptRepository) private var gptRepository
    @Injected(\.userDefaults) private var userDefaults
    @Injected(\.modelContext) private var modelContext
    
    override func beforeProvision() -> Bool {
        withAnimation {
            data = nil
        }
        return super.beforeProvision()
    }
    
    override func provideData() async throws -> [String]? {
        let urls = try await gptRepository.generateImage(
            prompt: prompt, 
            count: userDefaults.integerOr(forKey: APISettingsViewModel.RESPONSES_COUNT) ?? APISettingsViewModel.RESPONSES_COUNT_DEFAULT,
            apiKey: userDefaults.string(forKey: APISettingsViewModel.API_KEY) ?? APISettingsViewModel.API_KEY_DEFAULT
        )
        
        modelContext.insert(GeneratedImage(prompt: prompt, urls: urls))
        
        return urls
    }
}
