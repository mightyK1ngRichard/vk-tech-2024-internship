//
//  NewsEntity.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

struct NewsEntity: Decodable {
    let totalResults: Int?
    let articles: [ArticleEntity]
}
