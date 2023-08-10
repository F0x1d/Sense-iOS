//
//  UserDefaultsExtensions.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation

extension UserDefaults {
    func integerOr(forKey key: String) -> Int? {
        let result = integer(forKey: key)
        return result != 0 ? result : nil
    }
}
