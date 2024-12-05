//
//  YouTubeListPresenterTests.swift
//  VKNewsTests
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import XCTest
@testable import VKNews

final class YouTubeListPresenterTests: XCTestCase {
    private var presenter: YouTubeListPresenterProtocol?
    private var viewModel: YouTubeListViewModelProtocol?
    private let stubNetworkData = StubYouTubeNetworkData()

    override func setUpWithError() throws {
        viewModel = StubYouTubeViewModel()
        presenter = YouTubeListPresenter()
        presenter?.viewModel = viewModel
    }

    override func tearDownWithError() throws {
        viewModel = nil
        presenter = nil
    }

    func testPresentSnippetsList() {
        XCTAssertNotNil(presenter?.viewModel, "ViewModel must not be nil. Ensure it is set up correctly in setUpWithError.")

        // Arrange
        let response = stubNetworkData.snippets

        // Act
        presenter?.presentSnippetsList(response: response)

        let correctResult = [
            YouTubeSnippetModel(
                id: "2",
                title: Optional("Дмитрий"),
                description: Optional("Студент МГТУ им Н.Э.Баумана"),
                previewImageState: .loading,
                publishedAt: "October 29, 2015 at 8:27 AM",
                channelTitle: "Дмитрий Пермяков",
                getFromMemory: false
            ),
            YouTubeSnippetModel(
                id: "3",
                title: Optional("Про Дмитрия"),
                description: Optional("Мать студента МГТУ им Н.Э.Баумана"),
                previewImageState: .loading,
                publishedAt: "November 29, 2016 at 8:27 AM",
                channelTitle: "Елена Пермяков",
                getFromMemory: false
            )
        ]

        // Assert
        XCTAssertEqual(presenter?.viewModel?.snippets, correctResult)
    }
}
