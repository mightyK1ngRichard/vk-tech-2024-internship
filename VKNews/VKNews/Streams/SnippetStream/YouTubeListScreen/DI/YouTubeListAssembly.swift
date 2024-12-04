//
//  YouTubeListAssembly.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

final class YouTubeListAssembly {
    static let shared = YouTubeListAssembly()
    private init() {}

    func build() -> YouTubeListViewModel {
        let youTubeService = YouTubeSearchService(router: .search)
        let imageLoaderService = ImageLoaderService()
        let presenter = YouTubeListPresenter()
        let interactor = YouTubeListInteractor(presenter: presenter, youTubeService: youTubeService, imageLoaderService: imageLoaderService)
        let router = YouTubeListRouter()
        let viewModel = YouTubeListViewModel(interactor: interactor, router: router)
        presenter.viewModel = viewModel

        return viewModel
    }
}
