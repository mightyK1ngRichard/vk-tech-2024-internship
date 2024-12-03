//
//  YouTubeSearchService.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

protocol YouTubeSearchServiceProtocol {
    func getYouTubeVideos(req: YouTubeSearchServiceRequest) async throws -> YouTubeSearchResponse
}

final class YouTubeSearchService: YouTubeSearchServiceProtocol {

    private let urlSession: URLSession
    private let router: YouTubeNetworkRouter

    init(urlSession: URLSession = .shared, router: YouTubeNetworkRouter) {
        self.urlSession = urlSession
        self.router = router
    }
}

// MARK: - YouTubeSearchServiceProtocol

extension YouTubeSearchService {

    func getYouTubeVideos(req: YouTubeSearchServiceRequest) async throws -> YouTubeSearchResponse {
        guard
            let url = router.buildURL(apiKey: req.apiKey, query: req.query, maxResults: req.maxResults, pageToken: req.pageToken)
        else {
            throw YouTubeSearchNetworkError.invalidURL
        }

        let urlRequest = URLRequest(url: url)
        let (data, response) = try await urlSession.data(for: urlRequest)

        guard
            let response = response as? HTTPURLResponse,
            200..<300 ~= response.statusCode
        else {
            throw YouTubeSearchNetworkError.invalidHTTPResponse
        }

        let youTubeSearchResponse = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
        return youTubeSearchResponse
    }
}
