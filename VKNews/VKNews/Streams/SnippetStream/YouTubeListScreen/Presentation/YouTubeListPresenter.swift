//
//  YouTubeListPresenter.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

protocol YouTubeListPresenterProtocol: AnyObject {
    var viewModel: YouTubeListViewModelProtocol? { get set }
    func presentSnippetsList(response: YouTubeSearchResponseEntity)
    func addImageIntoSnippet(snippetID: String, imageResult: Result<Data, Error>)
    func presentError(error: Error)
    func getSnippetsFromMemory(snippets: [SDYouTubeSnippetModel])
    func didDeletedSuccessfully()
}

// MARK: - YouTubeListPresenter

final class YouTubeListPresenter: YouTubeListPresenterProtocol {

    weak var viewModel: YouTubeListViewModelProtocol?

    func presentSnippetsList(response: YouTubeSearchResponseEntity) {
        let snippets: [YouTubeSnippetModel] = response.items.compactMap { item in
            guard let id = item.id?.videoId, let snippet = item.snippet else {
                return nil
            }

            return YouTubeSnippetModel(
                id: id,
                title: snippet.title.isEmptyOrNil ? nil : snippet.title,
                description: snippet.description.isEmptyOrNil ? nil : snippet.description,
                // Данные об изображении уставновим в конкурентной очереди
                previewImageState: .loading,
                publishedAt: snippet.publishedAt?.formatDate ?? "",
                channelTitle: snippet.channelTitle ?? ""
            )
        }
        viewModel?.showSnippets(snippets, nextPageToken: response.nextPageToken)
    }

    func addImageIntoSnippet(snippetID: String, imageResult: Result<Data, Error>) {
        viewModel?.insertImageInSnippet(snippetID: snippetID, imageResult: imageResult)
    }

    func getSnippetsFromMemory(snippets: [SDYouTubeSnippetModel]) {
        let models = snippets.map { sdSnippet in
            YouTubeSnippetModel(sdModel: sdSnippet)
        }
        viewModel?.addSnippetsFromMemory(models)
    }

    func presentError(error: Error) {
        if let newsError = error as? YouTubeSearchNetworkError {
            viewModel?.showError(errorMessage: newsError.errorDescription)
            return
        }
        viewModel?.showError(errorMessage: error.localizedDescription)
    }

    func didDeletedSuccessfully() {
        viewModel?.didDeletedSuccessfully()
    }
}
