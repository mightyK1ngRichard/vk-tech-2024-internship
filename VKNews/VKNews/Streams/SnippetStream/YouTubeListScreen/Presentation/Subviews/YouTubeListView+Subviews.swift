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
        switch viewModel.screenState {
        case .loading, .initial:
            shimmeringContainer
        case .emptyView:
            emptyView
        case .success:
            contentContainer
        case let .error(message):
            errorView(message: message)
        }
    }

    var shimmeringContainer: some View {
        ForEach(0..<3) { _ in
            SnippetShimmeringView()
                .padding()
                .background(Constants.bgColor, in: .rect(cornerRadius: 16))
        }
    }

    var emptyView: some View {
        ContentUnavailableView.search.background(
            Constants.bgColor,
            in: .rect(cornerRadius: 8)
        )
        .padding()
    }

    func errorView(message: String) -> some View {
        ContentUnavailableView {
            Text("Error")
        } description: {
            Text(message)
        } actions: {
            Button("Fetch again") {
                viewModel.fetchData()
            }
            .buttonStyle(.borderedProminent)
        }
        .background(
            Constants.bgColor,
            in: .rect(cornerRadius: 8)
        )
        .padding()
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

#Preview("No Data") {
    YouTubeListView(viewModel: YouTubeListViewModelMock(fakeScreenState: .emptyView, delay: 1))
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
