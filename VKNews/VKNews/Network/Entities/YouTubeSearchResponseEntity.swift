//
//  YouTubeSearchResponseEntity.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

struct YouTubeSearchResponseEntity: Decodable {
    let nextPageToken: String?
    let prevPageToken: String?
    let regionCode: String
    let items: [YouTubeSearchItemEntity]
}
