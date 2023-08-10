//
//  KFImageExtensions.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import Kingfisher

extension KFImage {
    func saveableImage(_ image: KFCrossPlatformImage?) -> some View {
        self
            .resizable()
            .if(image != nil) { view in
                view.draggable(Image(uiImage: image!))
            }
            .if(image != nil) { view in
                view.contextMenu {
                    Button {
                        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
                    } label: {
                        Label("save_to_gallery", systemImage: "square.and.arrow.down")
                    }
                    
                    Button {
                        UIPasteboard.general.image = image!
                    } label: {
                        Label("copy", systemImage: "doc.on.doc")
                    }
                    
                    ShareLink(item: Image(uiImage: image!), preview: SharePreview("image", image: Image(uiImage: image!)))
                }
            }
    }
}
