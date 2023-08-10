//
//  BaseViewModel.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import Combine

@MainActor class BaseViewModel: ObservableObject {
    let backgroundQueue = DispatchQueue(label: "background")
    let mainQueue = DispatchQueue.main
    
    var cancellables = Set<AnyCancellable>()
}
