//
//  JSONParametersEncoder.swift
//  Sense
//
//  Created by Максим Зотеев on 13.09.2023.
//

import Foundation
import Alamofire

extension JSONParameterEncoder {
    static var openAI: JSONParameterEncoder {
        JSONParameterEncoder(encoder: JSONEncoder())
    }
}
