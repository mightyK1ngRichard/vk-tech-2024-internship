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
    var showLoading: Bool { get }
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
    private(set) var showLoading = false
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
        let request = YouTubeSearchServiceRequest(
            apiKey: "AIzaSyCKMoGNm795y7gcM2icFz39cbiadp0Ms70",
            query: "christmas",
            maxResults: "50",
            // FIXME: Убрать хадкод
            pageToken: "CDIQAA"
        )
        interactor?.fetchSnippets(req: request)
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
