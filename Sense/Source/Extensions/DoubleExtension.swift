//
//  DoubleExtension.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation

extension Double {
    func rounded(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
