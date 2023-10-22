//
//  HistoryView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import SwiftData
import Factory
import Kingfisher

struct HistoryView: View {
        
    @InjectedObject(\.historyViewModel) private var viewModel
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(
        sort: \GeneratedImage.date,
        order: .reverse,
        animation: .spring
    ) private var images: [GeneratedImage]
    
    var body: some View {
        NavigationSplitView {
            List(selection: $viewModel.selectedImage) {
                ForEach(images) { image in
                    NavigationLink(image.prompt, value: image)
                        .id(image.id)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(images[index])
                    }
                }
                .id(HistoryViewScrollAnchor.items)
            }
            .toolbar {
                if !images.isEmpty {
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            for image in images {
                                modelContext.delete(image)
                            }
                            ImageCache.default.clearCache()
                        } label: {
                            Image(systemName: "trash")
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("history")
        } detail: {
            if let image = viewModel.selectedImage {
                HistoryDetailsView(image: image)
                    .id(image.id)
            } else {
                Text("select_item")
                    .font(.title)
                    .bold()
                    .navigationTitle("")
            }
        }
    }
}

enum HistoryViewScrollAnchor {
    case items
}
