//
//  YouTubeSearchServiceRequest.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

struct YouTubeSearchServiceRequest {
    let apiKey: String
    let query: String
    let maxResults: String
    let pageToken: String?
    var order: String
}
