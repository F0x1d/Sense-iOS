//
//  GeneratedImage.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftData

@Model
class GeneratedImage {
    var prompt: String
    var urls: [String]
    var date = Date()
    
    init(prompt: String, urls: [String], date: Date = Date()) {
        self.prompt = prompt
        self.urls = urls
        self.date = date
    }
}
