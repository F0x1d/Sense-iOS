//
//  GenerateImageResponse.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation

struct GenerateImageResponse: Decodable {
    let data: [ImageData]
    
    struct ImageData: Decodable {
        let url: String
    }
}
