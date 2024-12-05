//
//  YouTubeSearchItemEntity.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

struct YouTubeSearchItemEntity: Decodable {
    let etag: String
    let id: SearchItemID?
    let snippet: SearchItemSnippetEntity?
}

// MARK: - SearchItemID

struct SearchItemID: Decodable {
    let videoId: String?
}

// MARK: - SearchItemSnippetEntity

struct SearchItemSnippetEntity: Decodable, Equatable {
    let publishedAt: String?
    let channelId: String?
    let title: String?
    let description: String?
    let thumbnails: SearchItemThumbnails?
    let channelTitle: String?
}

extension SearchItemSnippetEntity {

    static func == (lhs: SearchItemSnippetEntity, rhs: SearchItemSnippetEntity) -> Bool {
        lhs.publishedAt == rhs.publishedAt
        && lhs.channelId == rhs.channelId
        && lhs.title == rhs.title
        && lhs.description == rhs.description
        && lhs.thumbnails == rhs.thumbnails
        && lhs.channelTitle == rhs.channelTitle
    }
}

// MARK: - SearchItemThumbnails

struct SearchItemThumbnails: Decodable, Equatable {
    let high: ThumbnailsData?
}

extension SearchItemThumbnails {

    static func == (lhs: SearchItemThumbnails, rhs: SearchItemThumbnails) -> Bool {
        lhs.high == rhs.high
    }
}

// MARK: - ThumbnailsData

extension SearchItemThumbnails {

    struct ThumbnailsData: Decodable, Equatable {
        let url: String?
        let width: Int?
        let height: Int?
    }
}

extension SearchItemThumbnails.ThumbnailsData {

    static func == (lhs: SearchItemThumbnails.ThumbnailsData, rhs: SearchItemThumbnails.ThumbnailsData) -> Bool {
        lhs.url == rhs.url
        && lhs.width == rhs.width
        && lhs.height == rhs.height
    }
}
