//
//  HistoryDetailsView.swift
//  Sense
//
//  Created by Максим Зотеев on 10.08.2023.
//

import Foundation
import SwiftUI
import RealmSwift
import Factory

struct HistoryDetailsView: View {
    
    @StateObject private var viewModel: HistoryDetailsViewModel
    
    init(id: ObjectId) {
        _viewModel = StateObject(wrappedValue: Container.shared.historyDetailsViewModel(id))
    }
    
    var body: some View {
        List {
            if let image = viewModel.image {
                Section {
                    Text(image.prompt)
                        .textSelection(.enabled)
                }
                
                Section("response") {
                    ForEach(image.urls) { url in
                        ListAsyncImage(url: url)
                    }
                }
            }
        }
        .navigationTitle("details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
