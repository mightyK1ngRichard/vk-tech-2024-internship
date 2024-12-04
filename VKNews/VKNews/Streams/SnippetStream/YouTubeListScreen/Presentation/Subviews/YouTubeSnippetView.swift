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
        .background(Constants.bgColor, in: .rect(cornerRadius: 16))
    }
}

// MARK: - UI Subviews

private extension YouTubeSnippetView {

    var headerView: some View {
        HStack {
            Image(.person)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 24, height: 24)
                .padding(10)
                .background(.ultraThinMaterial, in: .circle)

            VStack(alignment: .leading, spacing: 3) {
                Text(snippet.channelTitle)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Constants.primaryTextColor)

                Text(snippet.publishedAt)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Constants.secondaryTextColor)
            }
            Spacer()

            if snippet.getFromMemory {
                VKBadge(text: "Saved")
                    .padding(.trailing, 3)
            }

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
    }

    var contentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = snippet.title {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Constants.primaryTextColor)
            }

            previewImageView

            if let description = snippet.description {
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .lineLimit(8)
                    .foregroundStyle(Constants.primaryTextColor)
            }
        }
    }

    var previewImageView: some View {
        VKPreviewImageView(imageState: snippet.previewImageState)
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

// MARK: - Constants

private extension YouTubeSnippetView {

    enum Constants {
        static let bgColor = VKColor<BackgroundPalette>.bgLightCharcoal.color
        static let primaryTextColor = VKColor<TextPalette>.primary.color
        static let secondaryTextColor = VKColor<TextPalette>.secondary.color
    }
}
