//
//  NewsListView.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import SwiftUI

struct NewsListView: View {
    @State var viewModel: NewsListViewModelProtocol

    var body: some View {
        NavigationStack {
            List(viewModel.news) { news in
                Text(news.title)
            }
            Button("Fetch") {
                viewModel.fetchData()
            }
        }
    }
}

// MARK: - Preview

#Preview("Mockable") {
    NewsListView(viewModel: NewsListViewModel.mockData)
}

#Preview("Network") {
    NewsListView(viewModel: NewsListAssembly.shared.build())
}
