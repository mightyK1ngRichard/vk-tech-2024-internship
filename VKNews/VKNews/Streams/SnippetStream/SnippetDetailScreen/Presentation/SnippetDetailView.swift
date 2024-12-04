//
//  SnippetDetailView.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import SwiftUI
import SwiftData

struct SnippetDetailView: View {
    @State var viewModel: SnippetDetailViewModelProtocol
    @Environment(\.modelContext) private var modelContext
    @Environment(Coordinator.self) private var coordinator

    var body: some View {
        mainContainer.onAppear {
            viewModel.setModelContext(modelContext: modelContext)
            viewModel.setCoordinator(coordinator: coordinator)
        }
        .alert(
            viewModel.errorMessage,
            isPresented: $viewModel.showingAlert,
            actions: {
                Button("OK", role: .cancel, action: viewModel.didTapCancelButton)
            }
        )
    }
}

// MARK: - Preview

#Preview("Mockable") {
    SnippetDetailView(
        viewModel: SnippetDetailAssembly.shared.build(
            snippet: .mockData,
            youTubeListViewModel: YouTubeListViewModelMock()
        )
    )
    .modelContainer(for: SDYouTubeSnippetModel.self, inMemory: true)
}
