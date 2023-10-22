//
//  HistoryDetailsView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import SwiftData
import Factory

struct HistoryDetailsView: View {
    
    @StateObject private var viewModel: HistoryDetailsViewModel
    
    init(image: GeneratedImage) {
        _viewModel = StateObject(wrappedValue: Container.shared.historyDetailsViewModel(image))
    }
    
    var body: some View {
        List {
            Section {
                Text(viewModel.image.prompt)
                    .textSelection(.enabled)
            }
            
            Section("response") {
                ForEach(viewModel.image.urls) { url in
                    ListAsyncImage(url: url)
                }
            }
        }
        .navigationTitle("details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
