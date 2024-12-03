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
    var snippets: [YouTubeSnippetModel] = []
    var errorMessage: String?

    func fetchData() {
        snippets = (0...20).map {
            .generateMockModel(for: String($0))
        }
    }

    func showSnippets(_ data: [YouTubeSnippetModel]) {}

    func showError(errorMessage: String) {}
}
#endif
