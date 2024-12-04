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

    var body: some View {
        mainContainer.onAppear {
            viewModel.setModelContext(modelContext: modelContext)
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
        viewModel: SnippetDetailAssembly.shared.build(snippet: .mockData)
    )
    .modelContainer(for: SDYouTubeSnippetModel.self, inMemory: true)
}
