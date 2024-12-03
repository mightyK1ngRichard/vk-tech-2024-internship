//
//  YouTubeListInteractor.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

protocol YouTubeListInteractorProtocol: AnyObject {
    func fetchSnippets(req: YouTubeSearchServiceRequest)
}

// MARK: - YouTubeListInteractor

final class YouTubeListInteractor: YouTubeListInteractorProtocol {

    var presenter: YouTubeListPresenterProtocol?
    private let youTubeService: YouTubeSearchServiceProtocol

    init(presenter: YouTubeListPresenterProtocol? = nil, youTubeService: YouTubeSearchServiceProtocol) {
        self.presenter = presenter
        self.youTubeService = youTubeService
    }
}

// MARK: - NewsListInteractorProtocol

extension YouTubeListInteractor {

    func fetchSnippets(req: YouTubeSearchServiceRequest) {
        Task {
            do {
                let response = try await youTubeService.getYouTubeVideos(req: req)
                presenter?.presentSnippetsList(response: response)
            } catch {
                Logger.log(kind: .error, message: error)
                presenter?.presentError(error: error)
            }
        }
    }
}
