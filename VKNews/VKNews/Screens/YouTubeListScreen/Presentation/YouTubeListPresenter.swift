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
        let snippets: [YouTubeSnippetModel] = response.items.compactMap { item in
            guard let id = item.id.videoId else {
                return nil
            }

            return YouTubeSnippetModel(
                id: id,
                title: item.snippet.title.isEmpty ? nil : item.snippet.title,
                description: item.snippet.description.isEmpty ? nil : item.snippet.description,
                // FIXME: Подумать
                previewImage: nil,
                publishedAt: item.snippet.publishedAt.formatDate ?? "",
                channelTitle: item.snippet.channelTitle
            )
        }
        viewModel?.showSnippets(snippets)
    }

    func presentError(error: Error) {
        if let newsError = error as? YouTubeSearchNetworkError {
            viewModel?.showError(errorMessage: newsError.errorDescription)
            return
        }
        viewModel?.showError(errorMessage: error.localizedDescription)
    }
}
