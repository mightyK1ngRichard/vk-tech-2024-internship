//
//  YouTubeListViewModel.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Observation

protocol YouTubeListViewModelProtocol: AnyObject {
    // Values
    var snippets: [YouTubeSnippetModel] { get }
    var errorMessage: String? { get }
    // Network
    func fetchData()
    // Display Data
    func showSnippets(_ data: [YouTubeSnippetModel])
    func showError(errorMessage: String)
}

// MARK: - YouTubeListViewModel

@Observable
final class YouTubeListViewModel: YouTubeListViewModelProtocol {
    @ObservationIgnored
    var interactor: YouTubeListInteractorProtocol?

    private(set) var snippets: [YouTubeSnippetModel] = []
    private(set) var errorMessage: String?

    init(
        interactor: YouTubeListInteractorProtocol? = nil,
        snippets: [YouTubeSnippetModel] = [],
        errorMessage: String? = nil
    ) {
        self.interactor = interactor
        self.snippets = snippets
        self.errorMessage = errorMessage
    }
}

// MARK: - Network

extension YouTubeListViewModel {

    func fetchData() {
//        let request = NewsServiceRequest(
//            apiKey: "5bb077a0181341b99bf6345c40f3b2d9",
//            query: "python",
//            page: "2",
//            pageSize: "10"
//        )
//        interactor?.fetchNews(req: request)
    }
}

// MARK: - Display Data

extension YouTubeListViewModel {

    func showSnippets(_ data: [YouTubeSnippetModel]) {
        snippets.append(contentsOf: data)
    }

    func showError(errorMessage: String) {
        self.errorMessage = errorMessage
    }
}
