//
//  BaseDataLoadingViewModel.swift
//  Sense
//
//  Created by Максим Зотеев on 06.07.2023.
//

import Foundation
import SwiftUI

class BaseDataLoadingViewModel<R>: BaseLoadViewModel {
    
    @Published var data: R? = nil
    
    func setData(_ data: R?) {
        withAnimation(.spring()) {
            self.data = data
        }
    }
    
    func provideData() async throws -> R? {
        return nil
    }
    
    override func provideData() async throws {
        setData(try await provideData())
    }
}
