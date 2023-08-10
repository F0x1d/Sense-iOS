//
//  BaseLoadViewModel.swift
//  Sense
//
//  Created by Максим Зотеев on 06.07.2023.
//

import Foundation
import SwiftUI

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
            self?.beforeProvision() ?? false
        } closure: { [weak self] in
            try await self?.provideData()
        } endClosure: { [weak self] in
            self?.providedData()
        } afterAll: { [weak self] in
            self?.doAfter()
        }
    }
    
    private func load(
        beforeClosure: () -> Bool,
        closure: () async throws -> Void,
        endClosure: () -> Void,
        afterAll: () -> Void
    ) async {
        do {
            if beforeClosure() {
                withAnimation(.spring()) {
                    self.loading = true
                }
                
                try await closure()
                endClosure()
            }
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
        
        afterAll()
    }
    
    func beforeProvision() -> Bool {
        return true
    }
    
    func provideData() async throws {
        
    }
    
    func providedData() {
        
    }
    
    func doAfter() {
        
    }
    
    func handleError(_ error: Error) async {
        
    }
}
