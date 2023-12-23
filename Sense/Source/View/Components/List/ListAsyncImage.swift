//
//  ListAsyncImage.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import Kingfisher

struct ListAsyncImage: View {
    let url: String
    
    @State private var image: KFCrossPlatformImage? = nil
    
    var body: some View {
        VStack {
            KFImage(URL(string: url)!)
                .cacheOriginalImage()
                .fade(duration: 0.2)
                .placeholder {
                    ProgressView()
                }
                .onSuccess { result in
                    self.image = result.image
                }
                .saveableImage(image)
        }
        .aspectRatio(1, contentMode: .fit)
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
    }
}
