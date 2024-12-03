//
//  NewsNetworkRouter.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

enum NewsNetworkRouter: String {
    static private var baseURLString = "https://newsapi.org/v2"

    case everything
}

extension NewsNetworkRouter {

    func buildURL(
        apiKey: String,
        query: String,
        page: String,
        pageSize: String
    ) -> URL? {
        let path = rawValue
        var urlComponents = URLComponents(string: NewsNetworkRouter.baseURLString + "/" + path)

        var queryItems: [URLQueryItem] = []
        let parameters: [String: String] = [
            "q": query,
            "page": "\(page)",
            "pageSize": "\(pageSize)"
        ]
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        queryItems.append(URLQueryItem(name: "apiKey", value: apiKey))

        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
}
