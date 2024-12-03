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
            ScrollView {
                ForEach(viewModel.snippets) { snippet in
                    LazyVStack {
                        YouTubeSnippetView(snippet: snippet).onAppear {
                            viewModel.loadMoreData(with: snippet)
                        }
                    }
                }

                if viewModel.showMoreLoading {
                    ProgressView()
                }
            }
            .background(.bar)
            .scrollIndicators(.hidden)
            .navigationTitle("Christmas")
        }
        .onAppear(perform: viewModel.fetchData)
    }
}

// MARK: - Preview

#Preview("Mockable") {
    YouTubeListView(viewModel: YouTubeListViewModelMock())
}

#Preview("Mockable Delay") {
    YouTubeListView(viewModel: YouTubeListViewModelMock(delay: 2))
}

#Preview("Network") {
    YouTubeListView(viewModel: YouTubeListAssembly.shared.build())
}
