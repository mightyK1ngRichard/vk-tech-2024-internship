//
//  SnippetDetailPresenter.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import Foundation

protocol SnippetDetailPresenterProtocol: AnyObject {
    // Values
    var viewModel: SnippetDetailViewModelProtocol? { get set }
    // Display
    func showError(_ errorMessage: String)
    func savedSuccessful(snippetID: String, title: String, description: String)
    func updateSnippetMemoryStatus()
}

// MARK: - SnippetDetailPresenter

final class SnippetDetailPresenter: SnippetDetailPresenterProtocol {
    weak var viewModel: SnippetDetailViewModelProtocol?

    func showError(_ errorMessage: String) {
        viewModel?.showError(errorMessage: errorMessage)
    }

    func savedSuccessful(snippetID: String, title: String, description: String) {
        viewModel?.savedSuccessful(snippetID: snippetID, title: title, description: description)
    }

    func updateSnippetMemoryStatus() {
        viewModel?.updateSnippetMemoryStatus()
    }
}
