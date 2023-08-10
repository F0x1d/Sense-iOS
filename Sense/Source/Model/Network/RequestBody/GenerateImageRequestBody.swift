//
//  GenerateImageRequestBody.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation

struct GenerateImageRequestBody: Encodable {
    let prompt: String
    let n: Int
}
