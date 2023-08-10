//
//  RepositoriesModule.swift
//  Sense
//
//  Created by Максим Зотеев on 05.07.2023.
//

import Foundation
import Factory

@RepositoryActor extension Container {
    var gptRepository: Factory<GPTRepository> {
        self { GPTRepository() }.singleton
    }
}
