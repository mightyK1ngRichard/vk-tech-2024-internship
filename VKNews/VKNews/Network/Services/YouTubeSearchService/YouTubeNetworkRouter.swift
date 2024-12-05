//
//  YouTubeNetworkRouter.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

enum YouTubeNetworkRouter: String {
    static private var baseURLString = "https://www.googleapis.com/youtube/v3"

    case search
}

extension YouTubeNetworkRouter {

    func buildURL(
        apiKey: String,
        query: String,
        maxResults: String,
        pageToken: String? = nil,
        order: String
    ) -> URL? {
        let path = rawValue
        var urlComponents = URLComponents(string: YouTubeNetworkRouter.baseURLString + "/" + path)

        var queryItems: [URLQueryItem] = []
        let parameters: [String: String] = [
            "part": "snippet",
            "q": query,
            "maxResults": maxResults,
            "key": apiKey,
            "order": order
        ]

        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }

        if let pageToken = pageToken {
            queryItems.append(URLQueryItem(name: "pageToken", value: pageToken))
        }

        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
}
