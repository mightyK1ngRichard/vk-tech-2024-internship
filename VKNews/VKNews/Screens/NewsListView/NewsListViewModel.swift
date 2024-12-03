//
//  NewsListViewModel.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Observation

protocol NewsListViewModelProtocol: AnyObject {
    // Values
    var news: [NewsModel] { get }
    var errorMessage: String? { get }
    // Network
    func fetchData()
    // Display Data
    func showNews(_ data: [NewsModel])
    func showError(errorMessage: String)
}

// MARK: - NewsListViewModel

@Observable
final class NewsListViewModel: NewsListViewModelProtocol {
    @ObservationIgnored
    var interactor: NewsListInteractorProtocol?

    private(set) var news: [NewsModel] = []
    private(set) var errorMessage: String?

    init(
        interactor: NewsListInteractorProtocol? = nil,
        news: [NewsModel] = [],
        errorMessage: String? = nil
    ) {
        self.interactor = interactor
        self.news = news
        self.errorMessage = errorMessage
    }
}

// MARK: - Network

extension NewsListViewModel {

    func fetchData() {
        let request = NewsServiceRequest(
            apiKey: "5bb077a0181341b99bf6345c40f3b2d9",
            query: "python",
            page: "2",
            pageSize: "10"
        )
        interactor?.fetchNews(req: request)
    }
}

// MARK: - Display Data

extension NewsListViewModel {

    func showNews(_ data: [NewsModel]) {
        news.append(contentsOf: data)
    }

    func showError(errorMessage: String) {
        self.errorMessage = errorMessage
    }
}
