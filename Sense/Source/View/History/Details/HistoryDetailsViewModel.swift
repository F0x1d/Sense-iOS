//
//  HistoryDetailsViewModel.swift
//  Sense
//
//  Created by Максим Зотеев on 07.08.2023.
//

import Foundation
import SwiftUI
import Combine
import RealmSwift

class HistoryDetailsViewModel: BaseViewModel {
    let id: ObjectId
    @Published var image: GeneratedImage? = nil
    
    init(_ id: ObjectId) {
        self.id = id
        super.init()
        
        try? Realm()
            .objects(GeneratedImage.self)
            .where { $0.realmId == id }
            .collectionPublisher
            .subscribe(on: backgroundQueue)
            .freeze()
            .map { $0.first }
            .removeDuplicates()
            .assertNoFailure()
            .receive(on: mainQueue)
            .assign(to: \.image, on: self)
            .store(in: &cancellables)
    }
}
