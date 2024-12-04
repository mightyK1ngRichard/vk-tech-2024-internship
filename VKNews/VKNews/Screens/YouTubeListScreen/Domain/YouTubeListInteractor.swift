//
//  YouTubeListInteractor.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation
import UIKit

protocol YouTubeListInteractorProtocol: AnyObject {
    func fetchSnippets(req: YouTubeSearchServiceRequest)
}

// MARK: - YouTubeListInteractor

final class YouTubeListInteractor: YouTubeListInteractorProtocol {

    var presenter: YouTubeListPresenterProtocol?
    private let youTubeService: YouTubeSearchServiceProtocol
    private let imageLoaderService: ImageLoaderServiceProtocol
    private var imagesLoadingTask: Task<Void, Never>?

    init(
        presenter: YouTubeListPresenterProtocol? = nil,
        youTubeService: YouTubeSearchServiceProtocol,
        imageLoaderService: ImageLoaderServiceProtocol
    ) {
        self.presenter = presenter
        self.youTubeService = youTubeService
        self.imageLoaderService = imageLoaderService
    }
}

// MARK: - NewsListInteractorProtocol

extension YouTubeListInteractor {

    func fetchSnippets(req: YouTubeSearchServiceRequest) {
//        guard imagesLoadingTask == nil else { return }

        imagesLoadingTask = Task {
            do {
                // Получаем снипеты
                let response = try await getSnippets(req: req)
                presenter?.presentSnippetsList(response: response)

                // Получаем изображения снипетов
                let stream = try await startLoadingImages(response.items)
                for try await (snippetID, image) in stream {
                    presenter?.addImageIntoSnippet(snippetID: snippetID, image: image)
                }
            } catch {
                Logger.log(kind: .error, message: error)
                presenter?.presentError(error: error)
                imagesLoadingTask = nil
            }
        }
    }
}

// MARK: - Helpers

private extension YouTubeListInteractor {

    func getSnippets(req: YouTubeSearchServiceRequest) async throws -> YouTubeSearchResponseEntity {
        try await youTubeService.getYouTubeVideos(req: req)
    }

    func startLoadingImages(
        _ snippets: [YouTubeSearchItemEntity]
    ) async throws -> AsyncThrowingStream<(id: String, image: UIImage), Error> {
        let imagesWithIDs: [(id: String, url: URL)] = snippets.compactMap {
            guard
                let id = $0.id.videoId,
                let url = URL(string: $0.snippet.thumbnails.high.url)
            else {
                Logger.log(kind: .error, message: "Для \($0.snippet.title) не найден ID")
                return nil
            }
            return (id: id, url: url)
        }

        return try await imageLoaderService.loadImages(from: imagesWithIDs)
    }
}
