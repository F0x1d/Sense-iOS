//
//  Message.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation

struct Message: Decodable, Encodable {
    let role: String
    let content: String
}
