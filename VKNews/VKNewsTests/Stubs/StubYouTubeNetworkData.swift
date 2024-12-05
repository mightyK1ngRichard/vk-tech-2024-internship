//
//  StubYouTubeNetworkData.swift
//  VKNewsTests
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import Foundation
@testable import VKNews

final class StubYouTubeNetworkData {

    lazy var snippets = YouTubeSearchResponseEntity(
        nextPageToken: "nextPageToken",
        prevPageToken: "prevPageToken",
        regionCode: "123456",
        items: [
            firstItem,
            secondItem
        ]
    )

    let firstItem = YouTubeSearchItemEntity(
        etag: "1",
        id: SearchItemID(videoId: "2"),
        snippet: SearchItemSnippetEntity(
            publishedAt: "2015-10-29T05:27:34Z",
            channelId: "3",
            title: "Дмитрий",
            description: "Студент МГТУ им Н.Э.Баумана",
            thumbnails: SearchItemThumbnails(
                high: SearchItemThumbnails.ThumbnailsData(
                    url: "https://sun9-52.userapi.com/impg/oSXWW7oZ327CMUCfXZeTniGuZbv2Q1hkSpWMfg/JTxbp8VDDZg.jpg?size=1620x2160&quality=95&sign=dc7aacb5644ae511037869fbfbddc3d9&type=album",
                    width: 300,
                    height: 150
                )
            ),
            channelTitle: "Дмитрий Пермяков"
        )
    )

    let secondItem = YouTubeSearchItemEntity(
        etag: "2",
        id: SearchItemID(videoId: "3"),
        snippet: SearchItemSnippetEntity(
            publishedAt: "2016-11-29T05:27:34Z",
            channelId: "4",
            title: "Про Дмитрия",
            description: "Мать студента МГТУ им Н.Э.Баумана",
            thumbnails: SearchItemThumbnails(
                high: SearchItemThumbnails.ThumbnailsData(
                    url: "https://sun9-13.userapi.com/c10706/u8850328/-6/w_1ad84789.jpg",
                    width: 300,
                    height: 150
                )
            ),
            channelTitle: "Елена Пермяков"
        )
    )
}
