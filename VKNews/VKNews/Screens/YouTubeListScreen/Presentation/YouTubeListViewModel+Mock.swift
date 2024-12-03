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
    var delay: TimeInterval

    init(
        snippets: [YouTubeSnippetModel] = [],
        errorMessage: String? = nil,
        showLoading: Bool = false,
        delay: TimeInterval = 0
    ) {
        self.snippets = snippets
        self.errorMessage = errorMessage
        self.showLoading = showLoading
        self.delay = delay
    }

    func fetchData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.snippets = (0...20).map {
                .generateMockModel(for: String($0))
            }
        }
    }

    func showSnippets(_ data: [YouTubeSnippetModel]) {}

    func showError(errorMessage: String) {}
}
#endif
