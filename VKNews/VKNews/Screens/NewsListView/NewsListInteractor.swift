//
//  NewsListInteractor.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

protocol NewsListInteractorProtocol: AnyObject {
    func fetchNews(req: NewsServiceRequest)
}

// MARK: - NewsListInteractor

final class NewsListInteractor: NewsListInteractorProtocol {

    var presenter: NewsListPresenterProtocol?
    private let newsService: NewsServiceProtocol

    init(presenter: NewsListPresenterProtocol? = nil, newsService: NewsServiceProtocol) {
        self.presenter = presenter
        self.newsService = newsService
    }
}

// MARK: - NewsListInteractorProtocol

extension NewsListInteractor {

    func fetchNews(req: NewsServiceRequest) {
        Task {
            do {
                let articles = try await newsService.getNews(req: req)
                presenter?.presentNewsList(response: articles)
            } catch {
                Logger.log(kind: .error, message: error)
                presenter?.presentError(error: error)
            }
        }
    }
}
