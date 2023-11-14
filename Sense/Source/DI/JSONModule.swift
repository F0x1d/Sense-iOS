//
//  JSONModule.swift
//  Sense
//
//  Created by Максим Зотеев on 14.11.2023.
//

import Foundation
import Factory

extension Container {
    
    var encoder: Factory<JSONEncoder> {
        self { JSONEncoder() }
    }
    
    var decoder: Factory<JSONDecoder> {
        self { JSONDecoder() }
    }
}
