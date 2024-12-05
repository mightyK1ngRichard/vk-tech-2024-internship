//
//  StubYouTubeListPresenter.swift
//  VKNewsTests
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import Foundation
@testable import VKNews

final class StubYouTubeListPresenter: YouTubeListPresenterProtocol {

    var viewModel: YouTubeListViewModelProtocol?
    private(set) var response: YouTubeSearchResponseEntity?
    private(set) var error: Error?

    func presentSnippetsList(response: YouTubeSearchResponseEntity) {
        self.response = response
    }
    
    func addImageIntoSnippet(snippetID: String, imageData: Data) {}
    
    func presentError(error: Error) {
        self.error = error
    }
    
    func getSnippetsFromMemory(snippets: [SDYouTubeSnippetModel]) {}
}
