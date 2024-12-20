//
//  YouTubeListView.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import SwiftUI

struct YouTubeListView: View {
    @State var viewModel: YouTubeListViewModelProtocol
    @State private var coordinator = Coordinator()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack(path: $coordinator.navPath) {
            ScrollView {
                screenStateView
            }
            .background(.bar)
            .scrollIndicators(.hidden)
            .navigationTitle("Christmas")
            .navigationDestination(for: YouTubeListRouter.Screens.self) { screen in
                openNextScreen(screen: screen)
            }
        }
        .environment(coordinator)
        .onAppear {
            viewModel.setCoordinator(with: coordinator)
            viewModel.setModelContext(modelContext: modelContext)
            viewModel.onAppear()
        }
    }
}

// MARK: - Navigation destination

private extension YouTubeListView {

    @ViewBuilder
    func openNextScreen(screen: YouTubeListRouter.Screens) -> some View {
        switch screen {
        case let .snippetCard(snippet):
            let vm = SnippetDetailAssembly.shared.build(
                snippet: snippet,
                youTubeListViewModel: viewModel
            )
            SnippetDetailView(viewModel: vm)
        }
    }
}

// MARK: - Preview

#Preview("Mockable") {
    YouTubeListView(viewModel: YouTubeListViewModelMock())
}

#Preview("No Data") {
    YouTubeListView(viewModel: YouTubeListViewModelMock(fakeScreenState: .emptyView, delay: 4))
}

#Preview("Mockable Delay") {
    YouTubeListView(viewModel: YouTubeListViewModelMock(delay: 2))
}

#Preview("Network") {
    YouTubeListView(viewModel: YouTubeListAssembly.shared.build())
}
