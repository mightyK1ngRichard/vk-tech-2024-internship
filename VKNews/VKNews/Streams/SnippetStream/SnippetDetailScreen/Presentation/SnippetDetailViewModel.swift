//
//  SnippetDetailViewModel.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import Foundation
import SwiftUI
import SwiftData

protocol SnippetDetailViewModelProtocol: AnyObject {
    // Values
    var inputTitle: String { get set }
    var inputDescription: String { get set }
    var showingAlert: Bool { get set }
    var buttonTitle: String { get }
    var errorMessage: String { get }
    var hasSnippetInMemory: Bool { get }
    var snippet: YouTubeSnippetModel { get }
    var isEditing: Bool { get }
    // Actions
    func checkSnippetIsSaved()
    func didTapEditButton()
    func didTapCancelButton()
    func didTapAlertButton()
    func didTapBackButton()
    func didTapDeleteButton()
    // Display data
    func showError(errorMessage: String)
    func savedSuccessful(snippetID: String, title: String, description: String)
    func updateSnippetMemoryStatus()
    // Setter
    func setModelContext(modelContext: ModelContext)
    func setCoordinator(coordinator: Coordinator)
}

// MARK: - SnippetDetailViewModel

@Observable
final class SnippetDetailViewModel: SnippetDetailViewModelProtocol {
    @ObservationIgnored
    var interactor: SnippetDetailInteractorProtocol?
    @ObservationIgnored
    var sharedViewModel: YouTubeListViewModelProtocol?

    var inputTitle: String
    var inputDescription: String
    var showingAlert = false
    let snippet: YouTubeSnippetModel
    private(set) var errorMessage = ""
    private(set) var isEditing = false
    private(set) var hasSnippetInMemory = false
    @ObservationIgnored
    private var coordinator: Coordinator?

    init(
        interactor: SnippetDetailInteractorProtocol? = nil,
        inputTitle: String = "",
        inputDescription: String = "",
        snippet: YouTubeSnippetModel,
        openEditView: Bool = false
    ) {
        self.interactor = interactor
        self.inputTitle = inputTitle.isEmpty ? snippet.title ?? "" : inputTitle
        self.inputDescription = inputDescription.isEmpty ? snippet.description ?? "" : inputDescription
        self.snippet = snippet
        self.isEditing = openEditView
        self.hasSnippetInMemory = snippet.getFromMemory
    }

    // MARK: Computed values

    var buttonTitle: String {
        isEditing ? "Save" : "Edit snippet data"
    }
}

// MARK: - Actions

extension SnippetDetailViewModel {

    func checkSnippetIsSaved() {
        guard !hasSnippetInMemory else { return }
        interactor?.fetchSnippet(snippetID: snippet.id)
    }

    func didTapEditButton() {
        // Если кнопка нажата, значит это режим сохранения
        guard isEditing else {
            withAnimation(.smooth(duration: 0.5, extraBounce: 0)) {
                isEditing = true
            }
            return
        }
        didTapSaveButton()
    }

    private func didTapSaveButton() {
        if inputTitle == snippet.title && inputDescription == snippet.description {
            withAnimation(.smooth(duration: 0.5, extraBounce: 0)) {
                isEditing = false
            }
            return
        }
        // Сохраняем изменения в памяти устройства
        interactor?.updateSnippetInMemory(
            snippetID: snippet.id,
            title: inputTitle,
            description: inputDescription
        )
    }

    func didTapCancelButton() {
        inputTitle = snippet.title ?? ""
        inputDescription = snippet.description ?? ""
        withAnimation(.smooth(duration: 0.5, extraBounce: 0)) {
            isEditing = false
        }
    }

    func didTapAlertButton() {
        didTapCancelButton()
    }

    func didTapBackButton() {
        coordinator?.openPreviousScreen()
    }

    func didTapDeleteButton() {
        sharedViewModel?.deleteSnippet(snippet: snippet)
        coordinator?.openPreviousScreen()
    }
}

// MARK: - Display data

extension SnippetDetailViewModel {

    func updateSnippetMemoryStatus() {
        hasSnippetInMemory = true
    }

    func showError(errorMessage: String) {
        showingAlert = true
        self.errorMessage = errorMessage
        Toast.shared.present(title: errorMessage)
    }

    func savedSuccessful(snippetID: String, title: String, description: String) {
        let newSnippet = YouTubeSnippetModel(
            id: snippetID,
            title: title,
            description: description,
            previewImageState: snippet.previewImageState,
            publishedAt: snippet.publishedAt,
            channelTitle: snippet.channelTitle,
            getFromMemory: snippet.getFromMemory
        )
        sharedViewModel?.didEditSnippet(snippet: newSnippet)

        Toast.shared.present(
            title: "Updated sussfully",
            icon: .checkmark,
            tint: VKColor<TextPalette>.green.color
        )
        coordinator?.openPreviousScreen()
    }
}

// MARK: - Setters

extension SnippetDetailViewModel {

    func setModelContext(modelContext: ModelContext) {
        interactor?.setModelContext(context: modelContext)
    }

    func setCoordinator(coordinator: Coordinator) {
        guard self.coordinator == nil else { return }
        self.coordinator = coordinator
    }
}
