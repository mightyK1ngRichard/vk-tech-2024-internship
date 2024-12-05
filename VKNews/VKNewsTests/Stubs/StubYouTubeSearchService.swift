//
//  StubYouTubeSearchService.swift
//  VKNewsTests
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import SwiftData
import Foundation
@testable import VKNews

final class StubYouTubeSearchService: YouTubeSearchServiceProtocol {
    let stubNetworkData: StubYouTubeNetworkData

    init(stubNetworkData: StubYouTubeNetworkData) {
        self.stubNetworkData = stubNetworkData
    }

    func getYouTubeVideos(req: YouTubeSearchServiceRequest) async throws -> YouTubeSearchResponseEntity {
        if req.apiKey != "test_api_key" {
            throw StubYouTubeSearchServiceError.badRequest
        }

        return stubNetworkData.snippets
    }
}

// MARK: - Error

extension StubYouTubeSearchService {

    enum StubYouTubeSearchServiceError: Error {
        case badRequest
        case incorrectToken
    }
}
