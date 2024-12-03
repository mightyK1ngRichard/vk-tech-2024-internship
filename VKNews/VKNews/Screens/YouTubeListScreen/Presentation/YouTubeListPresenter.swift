//
//  YouTubeListPresenter.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

protocol YouTubeListPresenterProtocol: AnyObject {
    func presentSnippetsList(response: YouTubeSearchResponse)
    func presentError(error: Error)
}

// MARK: - YouTubeListPresenter

final class YouTubeListPresenter: YouTubeListPresenterProtocol {

    weak var viewModel: YouTubeListViewModelProtocol?

    func presentSnippetsList(response: YouTubeSearchResponse) {
//        let articles: [NewsModel] = response.compactMap { articleEntity in
//            guard
//                let title = articleEntity.title,
//                let description = articleEntity.description
//            else { return nil }
//
//            return NewsModel(
//                id: UUID().uuidString,
//                author: articleEntity.author,
//                title: title,
//                description: description,
//                // FIXME: IOS-2: Добавить логику получения изображений
//                urlToImage: nil,
//                publishedAt: articleEntity.publishedAt
//            )
//        }
//        viewModel?.showNews(articles)
    }

    func presentError(error: Error) {
//        if let newsError = error as? NewsNetworkError {
//            viewModel?.showError(errorMessage: newsError.errorDescription)
//            return
//        }
//        viewModel?.showError(errorMessage: error.localizedDescription)
    }
}
