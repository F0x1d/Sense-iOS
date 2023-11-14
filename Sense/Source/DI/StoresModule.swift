//
//  StoresModule.swift
//  Sense
//
//  Created by Максим Зотеев on 14.11.2023.
//

import Foundation
import Factory

extension Container {
    var settingsStore: Factory<SettingsStore> {
        self { SettingsStore() }.singleton
    }
}
