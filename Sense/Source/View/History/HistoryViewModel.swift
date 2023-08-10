//
//  HistoryViewModel.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import RealmSwift
import Factory

class HistoryViewModel: BaseViewModel {
    @Published var selectedImage: GeneratedImage? = nil
    
    @Published var images = [GeneratedImage]()
    
    override init() {
        super.init()
        
        try? Realm()
            .objects(GeneratedImage.self)
            .sorted(byKeyPath: "date", ascending: false)
            .collectionPublisher
            .subscribe(on: backgroundQueue)
            .freeze()
            .map { Array($0) }
            .assertNoFailure()
            .receive(on: mainQueue)
            .assignWithAnimation(to: \.images, on: self)
            .store(in: &cancellables)
    }
    
    func delete(_ indexSet: IndexSet) {
        guard let realm = try? Realm() else { return }
                
        try? realm.write {
            for index in indexSet {
                guard let image = realm.object(ofType: GeneratedImage.self, forPrimaryKey: images[index].realmId) else { continue }
                realm.delete(image)
            }
        }
    }
    
    func deleteAll() {
        guard let realm = try? Realm() else { return }
        
        let images = realm.objects(GeneratedImage.self)
        realm.writeAsync {
            for image in images {
                realm.delete(image)
            }
        }
    }
}
