//
//  StubYouTubeViewModel.swift
//  VKNewsTests
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//


import XCTest
import SwiftData
@testable import VKNews

final class StubYouTubeViewModel: YouTubeListViewModelProtocol {
    var snippets: [YouTubeSnippetModel]
    var errorMessage: String?
    var screenState: ScreenState
    var showMoreLoading: Bool

    init(
        snippets: [YouTubeSnippetModel] = [],
        errorMessage: String? = nil,
        screenState: ScreenState = .initial,
        showMoreLoading: Bool = false
    ) {
        self.snippets = snippets
        self.errorMessage = errorMessage
        self.screenState = screenState
        self.showMoreLoading = showMoreLoading
    }
}

// MARK: - StubYouTubeViewModel

extension StubYouTubeViewModel {

    func onAppear() {}

    func fetchData() {}

    func loadMoreData(with snippet: YouTubeSnippetModel) {}

    func showSnippets(_ data: [YouTubeSnippetModel], nextPageToken: String?) {
        snippets = data
    }

    func addSnippetsFromMemory(_ data: [YouTubeSnippetModel]) {}

    func showError(errorMessage: String) {}

    func insertImageInSnippet(snippetID: String, imageData: Data) {}

    func setModelContext(modelContext: ModelContext) {}

    func setCoordinator(with coordinator: Coordinator) {}

    func didEditSnippet(snippet: YouTubeSnippetModel) {}

    func didTapSnippetCard(snippet: YouTubeSnippetModel) {}

    func deleteSnippet(snippet: YouTubeSnippetModel) {}
}
