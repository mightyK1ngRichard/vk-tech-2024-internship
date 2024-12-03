//
//  NewsNetworkError.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

enum NewsNetworkError: Error {
    case invalidURL
    case invalidHTTPResponse
}

extension NewsNetworkError {

    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidHTTPResponse:
            return "Invalid HTTP Response"
        }
    }
}
