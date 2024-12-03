//
//  NewsModel.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import UIKit

struct NewsModel: Identifiable {
    let id: String
    let author: String?
    let title: String
    let description: String
    let urlToImage: UIImage?
    let publishedAt: String?
}

// MARK: - Mockable

#if DEBUG
extension NewsModel: Mockable {

    static let mockData = NewsModel(
        id: "-1",
        author: "SelfExplainML",
        title: "PiML: Python Interpretable Machine Learning Toolbox",
        description: "PiML (Python Interpretable Machine Learning) toolbox for model development & diagnostics - SelfExplainML/PiML-Toolbox",
        urlToImage: .actions,
        publishedAt: "2024-11-05T15:25:44Z"
    )

    static func generateMockModel(for id: String) -> NewsModel {
        NewsModel(
            id: id,
            author: mockData.author,
            title: mockData.title,
            description: mockData.description,
            urlToImage: mockData.urlToImage,
            publishedAt: mockData.publishedAt
        )
    }
}
#endif
