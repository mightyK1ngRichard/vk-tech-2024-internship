//
//  YouTubeListInteractorTests.swift
//  VKNewsTests
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import XCTest
@testable import VKNews

final class YouTubeListInteractorTests: XCTestCase {
    private var iteractor: YouTubeListInteractorProtocol?
    private var stubNetworkData: StubYouTubeNetworkData!
    private var youTubeService: StubYouTubeSearchService!
    private var imageLoaderService: ImageLoaderServiceProtocol!
    private var stubPresenter: YouTubeListPresenterProtocol?

    override func setUpWithError() throws {
        stubNetworkData = StubYouTubeNetworkData()
        // presenter
        stubPresenter = StubYouTubeListPresenter()
        // iteractor
        youTubeService = StubYouTubeSearchService(stubNetworkData: stubNetworkData)
        imageLoaderService = ImageLoaderService()
        iteractor = YouTubeListInteractor(youTubeService: youTubeService, imageLoaderService: imageLoaderService)
        iteractor?.presenter = stubPresenter
    }

    override func tearDownWithError() throws {
        iteractor = nil
        stubNetworkData = nil
        youTubeService = nil
        stubPresenter = nil
        imageLoaderService = nil
    }

    func testIteractorFetchWithCorrectToken() throws {
        guard let presenter = iteractor?.presenter as? StubYouTubeListPresenter else {
            XCTFail("presenter must be StubYouTubeListPresenter. check setUpWithError")
            return
        }

        // Arrange
        let expectation = expectation(description: "Fetch Snippets")
        let firstRequest = YouTubeSearchServiceRequest(
            apiKey: "test_api_key",
            query: "проверка теста",
            maxResults: "1",
            pageToken: "nextPageToken"
        )

        // Act
        iteractor?.fetchSnippets(req: firstRequest)

        // Wait for async task to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)

        // Assert
        XCTAssertEqual(presenter.response?.items.count, stubNetworkData.snippets.items.count)
        XCTAssertEqual(presenter.response?.items.first?.etag, stubNetworkData.snippets.items.first?.etag)
        XCTAssertEqual(presenter.response?.items.first?.snippet, stubNetworkData.snippets.items.first?.snippet)
    }

    func testIteractorFetchWithIncorrectToken() throws {
        guard let presenter = iteractor?.presenter as? StubYouTubeListPresenter else {
            XCTFail("presenter must be StubYouTubeListPresenter. check setUpWithError")
            return
        }

        // Arrange
        let expectation = expectation(description: "Fetch Snippets")
        let firstRequest = YouTubeSearchServiceRequest(
            apiKey: "bad_api_token",
            query: "проверка теста",
            maxResults: "1",
            pageToken: "nextPageToken"
        )

        // Act
        iteractor?.fetchSnippets(req: firstRequest)

        // Wait for async task to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)

        // Assert
        XCTAssertEqual(
            presenter.error as? StubYouTubeSearchService.StubYouTubeSearchServiceError,
            StubYouTubeSearchService.StubYouTubeSearchServiceError.badRequest
        )
    }
}
