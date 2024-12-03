//
//  YouTubeListViewModel+Mock.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

#if DEBUG

@Observable
final class YouTubeListViewModelMock: YouTubeListViewModelProtocol {
    var snippets: [YouTubeSnippetModel]
    var errorMessage: String?
    var showLoading: Bool
    var showMoreLoading: Bool
    var delay: TimeInterval

    @ObservationIgnored
    private var lastSnippet: YouTubeSnippetModel? = nil
    @ObservationIgnored
    private var itemsCount = 0

    init(
        snippets: [YouTubeSnippetModel] = [],
        errorMessage: String? = nil,
        showLoading: Bool = false,
        showMoreLoading: Bool = false,
        delay: TimeInterval = 0
    ) {
        self.snippets = snippets
        self.errorMessage = errorMessage
        self.showLoading = showLoading
        self.showMoreLoading = showMoreLoading
        self.delay = delay
    }
}

extension YouTubeListViewModelMock {

    func fetchData() {
        showLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.snippets = (0...20).map {
                .generateMockModel(for: String($0))
            }
            self.lastSnippet = self.snippets.last
            self.itemsCount = 20
            self.showLoading = false
        }
    }

    func showError(errorMessage: String) {}

    func showSnippets(_ data: [YouTubeSnippetModel], nextPageToken: String?) {}

    func loadMoreData(with snippet: YouTubeSnippetModel) {
        guard snippet == lastSnippet else { return }
        showMoreLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let start = self.itemsCount + 1
            let end = self.itemsCount + 20
            let newSnippets: [YouTubeSnippetModel] = (start...end).map {
                .generateMockModel(for: String($0))
            }
            self.snippets.append(contentsOf: newSnippets)
            self.lastSnippet = newSnippets.last
            self.itemsCount = end
            self.showMoreLoading = false
        }
    }
}

#endif
