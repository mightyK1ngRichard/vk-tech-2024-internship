//
//  YouTubeSnippetModel.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import UIKit

struct YouTubeSnippetModel: Identifiable, Hashable, Equatable {
    let id: String
    let title: String?
    let description: String?
    var previewImageState: ImageState
    let publishedAt: String
    let channelTitle: String
}

// MARK: - Equatable

extension YouTubeSnippetModel {

    static func == (lhs: YouTubeSnippetModel, rhs: YouTubeSnippetModel) -> Bool {
        lhs.id == rhs.id
        && lhs.title == rhs.title
        && lhs.description == rhs.description
        && lhs.publishedAt == rhs.publishedAt
        && lhs.channelTitle == rhs.channelTitle
        && lhs.previewImageState == rhs.previewImageState
    }
}

// MARK: - Mockable

#if DEBUG
extension YouTubeSnippetModel: Mockable {

    static let mockData = YouTubeSnippetModel(
        id: "-1",
        title: "ABS-CBN Christmas Station IDs (2009-2021) 🎄🎄",
        description: "I made this playlist dahil excited na ko sa CSID for 2022. Sarap lang i reminisce and i celebrate ang BerMonths listening to these ...",
        previewImageState: .data(UIImage.preview.pngData() ?? Data()),
        publishedAt: "12 нояб в 12:21",
        channelTitle: "NPL Buddy"
    )

    static func generateMockModel(for id: String) -> YouTubeSnippetModel {
        YouTubeSnippetModel(
            id: id,
            title: "#\(id) - \(mockData.title ?? "without title")",
            description: mockData.description,
            previewImageState: mockData.previewImageState,
            publishedAt: mockData.publishedAt,
            channelTitle: mockData.channelTitle
        )
    }
}
#endif
