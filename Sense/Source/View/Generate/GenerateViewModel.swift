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
    @Injected(\.modelContext) private var modelContext
    
    override func provideData() async throws -> [String]? {
        withAnimation {
            data = nil
        }
        
        let urls = try await gptRepository.generateImage(prompt: prompt)
        modelContext.insert(GeneratedImage(prompt: prompt, urls: urls))
        
        return urls
    }
}
