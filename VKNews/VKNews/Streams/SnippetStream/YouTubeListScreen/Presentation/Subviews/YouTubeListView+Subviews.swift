//
//  YouTubeListView+Subviews.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import SwiftUI

extension YouTubeListView {

    @ViewBuilder
    var screenStateView: some View {
        if viewModel.showLoading {
            shimmeringContainer
        } else {
            contentContainer
        }
    }

    var shimmeringContainer: some View {
        ForEach(0..<3) { _ in
            SnippetShimmeringView()
                .padding()
                .background(Constants.bgColor, in: .rect(cornerRadius: 16))
        }
    }

    @ViewBuilder
    var contentContainer: some View {
        ForEach(viewModel.snippets, id: \.hashValue) { snippet in
            LazyVStack {
                YouTubeSnippetView(snippet: snippet).onAppear {
                    viewModel.loadMoreData(with: snippet)
                }
                .onTapGesture {
                    viewModel.didTapSnippetCard(snippet: snippet)
                }
            }
        }

        if viewModel.showMoreLoading {
            ProgressView().padding()
        }
    }
}

// MARK: - Preview

#Preview("Mockable") {
    YouTubeListView(viewModel: YouTubeListViewModelMock())
}

#Preview("Mockable Delay") {
    YouTubeListView(viewModel: YouTubeListViewModelMock(delay: 4))
}

#Preview("Network") {
    YouTubeListView(viewModel: YouTubeListAssembly.shared.build())
}

// MARK: - Constants

private extension YouTubeListView {

    enum Constants {
        static let bgColor = VKColor<BackgroundPalette>.bgLightCharcoal.color
    }
}
