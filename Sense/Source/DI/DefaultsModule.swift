//
//  DefaultsModule.swift
//  Sense
//
//  Created by Максим Зотеев on 06.07.2023.
//

import Foundation
import Factory

extension Container {
    var userDefaults: Factory<UserDefaults> {
        self { UserDefaults.standard }.singleton
    }
}
