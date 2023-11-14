//
//  BaseLoadViewModel.swift
//  Sense
//
//  Created by Максим Зотеев on 06.07.2023.
//

import Foundation
import SwiftUI
import Papyrus

class BaseLoadViewModel: BaseViewModel {
    
    @Published var loading = false
    @Published var error: String? = nil
    var showingError: Bool {
        get {
            error != nil
        }
        set {
            error = nil
        }
    }
    
    func startLoading() {
        Task { [weak self] in
            await self?.load()
        }
    }
    
    func load() async {
        await load { [weak self] in
            try await self?.provideData()
        }
    }
    
    private func load(closure: () async throws -> Void) async {
        withAnimation(.spring()) {
            self.loading = true
        }
        
        do {
            try await closure()
        } catch let error as ServerError {
            self.error = error.message
            await handleError(error)
        } catch let error {
            self.error = error.localizedDescription
            await handleError(error)
        }
        
        if self.loading {
            withAnimation(.spring()) {
                self.loading = false
            }
        }
    }
    
    func provideData() async throws {
        
    }
    
    func handleError(_ error: Error) async {
        guard let error = error as? PapyrusError else { return }
        self.error = error.message
    }
}
