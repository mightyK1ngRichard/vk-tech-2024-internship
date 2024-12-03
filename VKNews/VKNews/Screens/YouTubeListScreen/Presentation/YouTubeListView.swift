//
//  YouTubeListView.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import SwiftUI

struct YouTubeListView: View {
    @State var viewModel: YouTubeListViewModelProtocol

    var body: some View {
        NavigationStack {
            List(viewModel.snippets) { news in
                Text(news.title)
            }
            Button("Fetch") {
                viewModel.fetchData()
            }
        }
    }
}

// MARK: - Preview

#Preview("Mockable") {
    YouTubeListView(viewModel: YouTubeListViewModelMock())
}

#Preview("Network") {
    YouTubeListView(viewModel: YouTubeListAssembly.shared.build())
}
