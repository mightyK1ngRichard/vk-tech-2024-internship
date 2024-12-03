//
//  YouTubeListViewModel.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation
import Observation

protocol YouTubeListViewModelProtocol: AnyObject {
    // Values
    var snippets: [YouTubeSnippetModel] { get }
    var errorMessage: String? { get }
    var showLoading: Bool { get }
    var showMoreLoading: Bool { get }
    // Network
    func fetchData()
    func loadMoreData(with snippet: YouTubeSnippetModel)
    // Display Data
    func showSnippets(_ data: [YouTubeSnippetModel], nextPageToken: String?)
    func showError(errorMessage: String)
}

// MARK: - YouTubeListViewModel

@Observable
final class YouTubeListViewModel: YouTubeListViewModelProtocol {
    @ObservationIgnored
    var interactor: YouTubeListInteractorProtocol?
    
    /// Фрагменты видео
    private(set) var snippets: [YouTubeSnippetModel] = []
    /// Флаг показа стартовой загрузки
    private(set) var showLoading: Bool
    /// Флаг показа индикатора загрузки при бесконечном скролле
    private(set) var showMoreLoading: Bool
    /// Текст ошибки
    private(set) var errorMessage: String?
    
    /// Токен для следующей пагинации
    @ObservationIgnored
    private var nextPageToken: String?
    /// Последний показанный открывок на экране
    @ObservationIgnored
    private var lastSnippet: YouTubeSnippetModel?

    init(
        interactor: YouTubeListInteractorProtocol? = nil,
        snippets: [YouTubeSnippetModel] = [],
        showLoading: Bool = false,
        showMoreLoading: Bool = false,
        errorMessage: String? = nil
    ) {
        self.interactor = interactor
        self.snippets = snippets
        self.showLoading = showLoading
        self.showMoreLoading = showMoreLoading
        self.errorMessage = errorMessage
    }
}

// MARK: - Network

extension YouTubeListViewModel {

    func fetchData() {
        // Если последний сниппет и токен == nil, значит это первый запрос и показываем лоудер
        if lastSnippet == nil && nextPageToken == nil {
            showLoading = true
        }

        let request = YouTubeSearchServiceRequest(
            apiKey: "AIzaSyCKMoGNm795y7gcM2icFz39cbiadp0Ms70",
            query: "christmas",
            maxResults: "10",
            pageToken: nextPageToken
        )
        interactor?.fetchSnippets(req: request)
    }

    func loadMoreData(with snippet: YouTubeSnippetModel) {
        guard snippet == lastSnippet else { return }
        showMoreLoading = true
        fetchData()
    }
}

// MARK: - Display Data

extension YouTubeListViewModel {

    func showSnippets(_ data: [YouTubeSnippetModel], nextPageToken: String?) {
        DispatchQueue.main.async {
            self.snippets.append(contentsOf: data)
            self.nextPageToken = nextPageToken
            self.lastSnippet = data.last
            self.showLoading = false
            self.showMoreLoading = false
        }
    }

    func showError(errorMessage: String) {
        DispatchQueue.main.async {
            self.errorMessage = errorMessage
        }
    }
}
