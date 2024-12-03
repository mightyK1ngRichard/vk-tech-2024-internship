//
//  NewsListViewModel+Mock.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

#if DEBUG
extension NewsListViewModel: Mockable {

    static var mockData: NewsListViewModel {
        NewsListViewModel(
            news: (0...20).map { .generateMockModel(for: String($0)) }
        )
    }
}
#endif
