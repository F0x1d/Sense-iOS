//
//  HistoryDetailsViewModel.swift
//  Sense
//
//  Created by Максим Зотеев on 07.08.2023.
//

import Foundation
import SwiftUI

class HistoryDetailsViewModel: BaseViewModel {
    let image: GeneratedImage
    
    init(_ image: GeneratedImage) {
        self.image = image
    }
}
