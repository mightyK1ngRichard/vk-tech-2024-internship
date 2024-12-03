//
//  NewsService.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

protocol NewsServiceProtocol {
    func getNews(req: NewsServiceRequest) async throws -> [ArticleEntity]
}

final class NewsService: NewsServiceProtocol {

    private let urlSession: URLSession
    private let router: NewsNetworkRouter

    init(urlSession: URLSession = .shared, router: NewsNetworkRouter) {
        self.urlSession = urlSession
        self.router = router
    }
}

// MARK: - NewsServiceProtocol

extension NewsService {

    func getNews(req: NewsServiceRequest) async throws -> [ArticleEntity] {
        guard
            let url = router.buildURL(apiKey: req.apiKey, query: req.query, page: req.page, pageSize: req.pageSize)
        else {
            throw NewsNetworkError.invalidURL
        }

        let urlRequest = URLRequest(url: url)
        let (data, response) = try await urlSession.data(for: urlRequest)

        guard
            let response = response as? HTTPURLResponse,
            200..<300 ~= response.statusCode
        else {
            throw NewsNetworkError.invalidHTTPResponse
        }

        let news = try JSONDecoder().decode(NewsEntity.self, from: data)
        return news.articles
    }
}
