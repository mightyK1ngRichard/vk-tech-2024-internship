//
//  YouTubeSnippetView.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import SwiftUI

struct YouTubeSnippetView: View {
    let snippet: YouTubeSnippetModel

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            headerView
            contentView
        }
        .padding(.vertical, 14)
        .padding(.horizontal)
        .background(.white)
    }
}

// MARK: - UI Subviews

private extension YouTubeSnippetView {

    var headerView: some View {
        HStack {
            Image(.defaultAvatar)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 42, height: 42)
                .clipShape(.circle)

            VStack(alignment: .leading, spacing: 3) {
                Text(snippet.channelTitle)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.primary)

                Text(snippet.publishedAt)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.secondary)
            }
        }
    }

    var contentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(snippet.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)

            if let uiImage = snippet.previewImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 192)
                    .clipShape(.rect(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 192)
            }

            Text(snippet.description)
                .font(.system(size: 14, weight: .regular))
                .lineLimit(8)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Rectangle()
            .fill(.bar)

        YouTubeSnippetView(snippet: .mockData)
    }
    .ignoresSafeArea()
}
