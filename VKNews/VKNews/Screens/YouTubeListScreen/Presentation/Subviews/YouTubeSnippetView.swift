//
//  YouTubeSnippetView.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import SwiftUI

struct YouTubeSnippetView: View {
    var body: some View {
        Text("NewsCellView")
    }
}

// MARK: - UI Subviews

private extension YouTubeSnippetView {

    var headerView: some View {
        HStack {
            Image(systemName: "person")
                .frame(width: 42, height: 42)
        }
    }
}

// MARK: - Preview

#Preview {
    YouTubeSnippetView()
}
