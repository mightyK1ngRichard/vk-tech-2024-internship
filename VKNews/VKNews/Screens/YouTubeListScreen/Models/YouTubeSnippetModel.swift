//
//  YouTubeSnippetModel.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import UIKit

struct YouTubeSnippetModel: Identifiable {
    let id: String
    let title: String
    let description: String
    let previewImage: UIImage?
    let publishedAt: String
    let channelTitle: String
}

// MARK: - Mockable

#if DEBUG
extension YouTubeSnippetModel: Mockable {

    static let mockData = YouTubeSnippetModel(
        id: "-1",
        title: "ABS-CBN Christmas Station IDs (2009-2021) 🎄🎄",
        description: "I made this playlist dahil excited na ko sa CSID for 2022. Sarap lang i reminisce and i celebrate ang BerMonths listening to these ...",
        previewImage: .actions,
        publishedAt: "2022-10-15 02:28:57",
        channelTitle: "NPL Buddy"
    )

    static func generateMockModel(for id: String) -> YouTubeSnippetModel {
        YouTubeSnippetModel(
            id: id,
            title: mockData.title,
            description: mockData.description,
            previewImage: mockData.previewImage,
            publishedAt: mockData.publishedAt,
            channelTitle: mockData.channelTitle
        )
    }
}
#endif
