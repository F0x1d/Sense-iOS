//
//  HistoryView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import RealmSwift
import Factory
import Kingfisher

struct HistoryView: View {
        
    @InjectedObject(\.historyViewModel) private var viewModel
    
    var body: some View {
        NavigationSplitView {
            List(selection: $viewModel.selectedImage) {
                ForEach(viewModel.images) { image in
                    NavigationLink(image.prompt, value: image)
                        .id(image.realmId)
                }
                .onDelete { viewModel.delete($0) }
                .id(HistoryViewScrollAnchor.items)
            }
            .toolbar {
                if !viewModel.images.isEmpty {
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            viewModel.deleteAll()
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
                HistoryDetailsView(id: image.realmId)
                    .id(image.realmId)
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
