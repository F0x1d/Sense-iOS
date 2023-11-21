//
//  CacheSettingsViewModel.swift
//  Sense
//
//  Created by Максим Зотеев on 06.07.2023.
//

import Foundation
import SwiftUI
import Kingfisher

final class CacheSettingsViewModel: BaseViewModel {
    
    @Published var cacheSize = -1
            
    func updateCacheSize() {
        ImageCache.default.calculateDiskStorageSize { [weak self] result in
            self?.cacheSize = Int((try? result.get()) ?? 0)
        }
    }
        
    func clearCache() {
        ImageCache.default.clearCache() { [weak self] in
            self?.updateCacheSize()
        }
    }
}
