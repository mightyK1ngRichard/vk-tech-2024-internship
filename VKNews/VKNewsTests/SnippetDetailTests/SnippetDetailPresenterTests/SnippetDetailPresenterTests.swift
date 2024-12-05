//
//  SnippetDetailPresenterTests.swift
//  VKNewsTests
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import XCTest
@testable import VKNews

final class SnippetDetailPresenterTests: XCTestCase {
    var presenter: SnippetDetailPresenterProtocol?
    var stubViewModel: SnippetDetailViewModelProtocol?

    override func setUpWithError() throws {
        presenter = SnippetDetailPresenter()
        stubViewModel = StubSnippetDetailViewModel(snippet: .mockData)
        presenter?.viewModel = stubViewModel
    }

    override func tearDownWithError() throws {
    }

    func testSavedSuccessful() {
        // Arrange
        let snippetID = "snippetID"
        let title = "title"
        let description = "description"

        // Act
        presenter?.savedSuccessful(
            snippetID: snippetID,
            title: title,
            description: description
        )

        // Assert
        let correntSnippet = YouTubeSnippetModel(
            id: "snippetID",
            title: Optional("title"),
            description: Optional("description"),
            previewImageState: .data(UIImage.stubUI.pngData() ?? Data()),
            publishedAt: "12 нояб в 12:21",
            channelTitle: "NPL Buddy",
            getFromMemory: true
        )

        XCTAssertEqual(presenter?.viewModel?.snippet, correntSnippet)
    }
}
