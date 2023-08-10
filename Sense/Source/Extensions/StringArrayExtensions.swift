//
//  StringArrayExtensions.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import RealmSwift

extension [String] {
    func toRealmList() -> RealmSwift.List<String> {
        let list = RealmSwift.List<String>()
        list.append(objectsIn: self)
        return list
    }
}
