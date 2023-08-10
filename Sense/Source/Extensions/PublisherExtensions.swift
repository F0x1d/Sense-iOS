//
//  PublisherExtensions.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import Combine

// Fixes memory leak
extension Publisher where Failure == Never {
    
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
        sink { [weak root] in
            root?[keyPath: keyPath] = $0
        }
    }
    
    func assignWithAnimation<Root: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<Root, Output>,
        on root: Root,
        animation: Animation? = .default
    ) -> AnyCancellable {
        sink { [weak root] data in
            withAnimation(animation) {
                root?[keyPath: keyPath] = data
            }
        }
    }
}
