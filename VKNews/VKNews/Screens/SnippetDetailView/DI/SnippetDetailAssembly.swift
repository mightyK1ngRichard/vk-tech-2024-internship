//
//  SnippetDetailAssembly.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import Foundation

final class SnippetDetailAssembly {
    static let shared = SnippetDetailAssembly()
    private init() {}

    func build(snippet: YouTubeSnippetModel) -> SnippetDetailViewModel {
        let presenter = SnippetDetailPresenter()
        let interactor = SnippetDetailInteractor(presenter: presenter)
        let viewModel = SnippetDetailViewModel(interactor: interactor, snippet: snippet)
        presenter.viewModel = viewModel

        return viewModel
    }
}
