//
//  YouTubeListPresenter.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation
import UIKit

protocol YouTubeListPresenterProtocol: AnyObject {
    func presentSnippetsList(response: YouTubeSearchResponseEntity)
    func addImageIntoSnippet(snippetID: String, image: UIImage)
    func presentError(error: Error)
}

// MARK: - YouTubeListPresenter

final class YouTubeListPresenter: YouTubeListPresenterProtocol {

    weak var viewModel: YouTubeListViewModelProtocol?

    func presentSnippetsList(response: YouTubeSearchResponseEntity) {
        let snippets: [YouTubeSnippetModel] = response.items.compactMap { item in
            guard let id = item.id.videoId else {
                return nil
            }

            return YouTubeSnippetModel(
                id: id,
                title: item.snippet.title.isEmpty ? nil : item.snippet.title,
                description: item.snippet.description.isEmpty ? nil : item.snippet.description,
                // Картинки будут добавляеться далее через стриминг
                previewImageState: .loading,
                publishedAt: item.snippet.publishedAt.formatDate ?? "",
                channelTitle: item.snippet.channelTitle
            )
        }
        viewModel?.showSnippets(snippets, nextPageToken: response.nextPageToken)
    }

    func addImageIntoSnippet(snippetID: String, image: UIImage) {
        viewModel?.insertImageInSnippet(snippetID: snippetID, image: image)
    }

    func presentError(error: Error) {
        if let newsError = error as? YouTubeSearchNetworkError {
            viewModel?.showError(errorMessage: newsError.errorDescription)
            return
        }
        viewModel?.showError(errorMessage: error.localizedDescription)
    }
}
