//
//  ArticleEntity.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

struct ArticleEntity: Decodable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    let source: ArticleSource?
}

// MARK: - ArticleSource

extension ArticleEntity {

    struct ArticleSource: Decodable {
        let name: String?
    }
}
