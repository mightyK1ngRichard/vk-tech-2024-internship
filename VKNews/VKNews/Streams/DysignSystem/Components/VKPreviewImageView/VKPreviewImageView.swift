//
//  VKPreviewImageView.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import SwiftUI

struct VKPreviewImageView: View {
    let imageState: ImageState

    var body: some View {
        previewImageView
    }
}

// MARK: - UI Subviews

private extension VKPreviewImageView {

    @ViewBuilder
    var previewImageView: some View {
        switch imageState {
        case .loading:
            ShimmeringView()
                .clipShape(.rect(cornerRadius: 8))
                .frame(height: 192)
        case .none:
            emptyView
        case let .data(imageData):
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 192)
                    .clipShape(.rect(cornerRadius: 8))
            } else {
                emptyView
            }
        }
    }

    var emptyView: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.ultraThinMaterial)
            .frame(height: 192)
            .overlay {
                Image(systemName: "photo.badge.exclamationmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 24)
                    .foregroundStyle(.secondary)
            }
    }
}

// MARK: - Preview

#Preview("Image") {
    VKPreviewImageView(imageState: .data(UIImage.preview.pngData()!))
        .padding(.horizontal)
}

#Preview("Loading") {
    VKPreviewImageView(imageState: .loading)
        .padding(.horizontal)
}

#Preview("Empty") {
    VKPreviewImageView(imageState: .none)
        .padding(.horizontal)
}
