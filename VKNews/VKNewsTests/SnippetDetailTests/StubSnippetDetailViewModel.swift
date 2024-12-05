//
//  StubSnippetDetailViewModel.swift
//  VKNewsTests
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import Foundation
import SwiftData
@testable import VKNews

final class StubSnippetDetailViewModel: SnippetDetailViewModelProtocol {
    var inputTitle = ""
    var inputDescription = ""
    var buttonTitle = ""
    var errorMessage = ""
    var showingAlert = false
    var hasSnippetInMemory = false
    var isEditing = false
    var snippet: YouTubeSnippetModel

    init(
        inputTitle: String = "",
        inputDescription: String = "",
        buttonTitle: String = "",
        errorMessage: String = "",
        showingAlert: Bool = false,
        hasSnippetInMemory: Bool = false,
        isEditing: Bool = false,
        snippet: YouTubeSnippetModel
    ) {
        self.inputTitle = inputTitle
        self.inputDescription = inputDescription
        self.buttonTitle = buttonTitle
        self.errorMessage = errorMessage
        self.showingAlert = showingAlert
        self.hasSnippetInMemory = hasSnippetInMemory
        self.isEditing = isEditing
        self.snippet = snippet
    }

    func checkSnippetIsSaved() {}
    
    func didTapEditButton() {}
    
    func didTapCancelButton() {}
    
    func didTapAlertButton() {}
    
    func didTapBackButton() {}
    
    func didTapDeleteButton() {}
    
    func showError(errorMessage: String) {}
    
    func savedSuccessful(snippetID: String, title: String, description: String) {
        snippet = YouTubeSnippetModel(
            id: snippetID,
            title: title,
            description: description,
            previewImageState: snippet.previewImageState,
            publishedAt: snippet.publishedAt,
            channelTitle: snippet.channelTitle,
            getFromMemory: snippet.getFromMemory
        )
    }
    
    func updateSnippetMemoryStatus() {}
    
    func setModelContext(modelContext: ModelContext) {}
    
    func setCoordinator(coordinator: Coordinator) {}
}
