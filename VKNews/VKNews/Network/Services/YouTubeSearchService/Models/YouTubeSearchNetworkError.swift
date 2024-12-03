//
//  YouTubeSearchNetworkError.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

enum YouTubeSearchNetworkError: Error {
    case invalidURL
    case invalidHTTPResponse
}

extension YouTubeSearchNetworkError {

    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidHTTPResponse:
            return "Invalid HTTP Response"
        }
    }
}
