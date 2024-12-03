//
//  NewsListAssembly.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

final class NewsListAssembly {
    static let shared = NewsListAssembly()
    private init() {}

    func build() -> NewsListViewModel {
        let newsService = NewsService(router: .everything)
        let presenter = NewsListPresenter()
        let interactor = NewsListInteractor(presenter: presenter, newsService: newsService)
        let viewModel = NewsListViewModel(interactor: interactor)
        presenter.viewModel = viewModel

        return viewModel
    }
}
