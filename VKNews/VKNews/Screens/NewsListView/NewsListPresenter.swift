//
//  NewsListPresenter.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

protocol NewsListPresenterProtocol: AnyObject {
    func presentNewsList(response: [ArticleEntity])
    func presentError(error: Error)
}

// MARK: - NewsListPresenter

final class NewsListPresenter: NewsListPresenterProtocol {

    weak var viewModel: NewsListViewModelProtocol?

    func presentNewsList(response: [ArticleEntity]) {
        let articles: [NewsModel] = response.compactMap { articleEntity in
            guard
                let title = articleEntity.title,
                let description = articleEntity.description
            else { return nil }

            return NewsModel(
                id: UUID().uuidString,
                author: articleEntity.author,
                title: title,
                description: description,
                // FIXME: IOS-2: Добавить логику получения изображений
                urlToImage: nil,
                publishedAt: articleEntity.publishedAt
            )
        }
        viewModel?.showNews(articles)
    }

    func presentError(error: Error) {
        if let newsError = error as? NewsNetworkError {
            viewModel?.showError(errorMessage: newsError.errorDescription)
            return
        }
        viewModel?.showError(errorMessage: error.localizedDescription)
    }
}
