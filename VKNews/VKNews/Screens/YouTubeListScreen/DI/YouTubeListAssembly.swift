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
        let presenter = YouTubeListPresenter()
        let interactor = YouTubeListInteractor(presenter: presenter, youTubeService: youTubeService)
        let viewModel = YouTubeListViewModel(interactor: interactor)
        presenter.viewModel = viewModel

        return viewModel
    }
}
