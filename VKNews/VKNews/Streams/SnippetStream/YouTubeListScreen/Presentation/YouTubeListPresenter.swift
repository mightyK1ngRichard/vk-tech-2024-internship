//
//  YouTubeListPresenter.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

protocol YouTubeListPresenterProtocol: AnyObject {
    func presentSnippetsList(response: YouTubeSearchResponseEntity)
    func addImageIntoSnippet(snippetID: String, imageData: Data)
    func presentError(error: Error)
    func getSnippetsFromMemory(snippets: [SDYouTubeSnippetModel])
}

// MARK: - YouTubeListPresenter

final class YouTubeListPresenter: YouTubeListPresenterProtocol {

    weak var viewModel: YouTubeListViewModelProtocol?

    func presentSnippetsList(response: YouTubeSearchResponseEntity) {
        let snippets: [YouTubeSnippetModel] = response.items.compactMap { item in
            guard
                let id = item.id?.videoId,
                let snippet = item.snippet
            else {
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

    func addImageIntoSnippet(snippetID: String, imageData: Data) {
        viewModel?.insertImageInSnippet(snippetID: snippetID, imageData: imageData)
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
}
