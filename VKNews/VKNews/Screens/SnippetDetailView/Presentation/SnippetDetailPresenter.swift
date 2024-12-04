//
//  SnippetDetailPresenter.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import Foundation

protocol SnippetDetailPresenterProtocol: AnyObject {
    func showError(_ errorMessage: String)
    func savedSuccessful()
}

// MARK: - SnippetDetailPresenter

final class SnippetDetailPresenter: SnippetDetailPresenterProtocol {
    weak var viewModel: SnippetDetailViewModelProtocol?

    func showError(_ errorMessage: String) {
        viewModel?.showError(errorMessage: errorMessage)
    }

    func savedSuccessful() {
        viewModel?.savedSuccessful()
    }
}
