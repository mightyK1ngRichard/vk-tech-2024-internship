//
//  YouTubeSearchItemEntity.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

struct YouTubeSearchItemEntity: Decodable {
    let etag: String
    let id: SearchItemID
    let snippet: SearchItemSnippetEntity
}

// MARK: - SearchItemID

struct SearchItemID: Decodable {
    let videoId: String?
}

// MARK: - SearchItemSnippetEntity

struct SearchItemSnippetEntity: Decodable {
    let publishedAt: String
    let channelId: String
    let title: String
    let description: String
    let thumbnails: SearchItemThumbnails
    let channelTitle: String
}

// MARK: - SearchItemThumbnails

struct SearchItemThumbnails: Decodable {
    let high: ThumbnailsData
}

extension SearchItemThumbnails {

    struct ThumbnailsData: Decodable {
        let url: String
        let width: Int
        let height: Int
    }
}
