//
//  YouTubeListViewModel+Mock.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

#if DEBUG

import Foundation
import UIKit
import SwiftData

@Observable
final class YouTubeListViewModelMock: YouTubeListViewModelProtocol {
    var snippets: [YouTubeSnippetModel]
    var errorMessage: String?
    var screenState: ScreenState
    var showMoreLoading: Bool
    var delay: TimeInterval
    var fakeScreenState: ScreenState? = nil

    @ObservationIgnored
    private var lastSnippet: YouTubeSnippetModel? = nil
    @ObservationIgnored
    private var itemsCount = 0

    init(
        fakeScreenState: ScreenState? = nil,
        snippets: [YouTubeSnippetModel] = [],
        errorMessage: String? = nil,
        screenState: ScreenState = .initial,
        showMoreLoading: Bool = false,
        delay: TimeInterval = 0
    ) {
        self.fakeScreenState = fakeScreenState
        self.snippets = snippets
        self.errorMessage = errorMessage
        self.screenState = screenState
        self.showMoreLoading = showMoreLoading
        self.delay = delay
    }
}

extension YouTubeListViewModelMock {

    func onAppear() {
        fetchData()
    }

    func fetchData() {
        screenState = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if let fakeScreenState = self.fakeScreenState {
                self.screenState = fakeScreenState
                return
            }
            self.snippets = (0...20).map {
                .generateMockModel(for: String($0))
            }
            self.lastSnippet = self.snippets.last
            self.itemsCount = 20
            self.screenState = .success
        }
    }

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

    func deleteSnippet(snippet: YouTubeSnippetModel) {
        guard let index = (snippets.firstIndex { $0.id == snippet.id }) else {
            return
        }
        snippets.remove(at: index)
    }

    func showError(errorMessage: String) {}

    func showSnippets(_ data: [YouTubeSnippetModel], nextPageToken: String?) {}

    func insertImageInSnippet(snippetID: String, imageData: Data) {}

    func setModelContext(modelContext: ModelContext) {}

    func didTapSnippetCard(snippet: YouTubeSnippetModel) {}

    func setCoordinator(with coordinator: Coordinator) {}

    func addSnippetsFromMemory(_ data: [YouTubeSnippetModel]) {}

    func didEditSnippet(snippet: YouTubeSnippetModel) {}
}

#endif
