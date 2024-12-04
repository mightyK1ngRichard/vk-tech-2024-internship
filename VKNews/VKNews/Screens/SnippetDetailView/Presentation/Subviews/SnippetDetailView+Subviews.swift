//
//  SnippetDetailView+Subviews.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import SwiftUI

extension SnippetDetailView {

    var mainContainer: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                titleView
                snippetPreviewImageView
                descriptionView
                buttonsConstainer
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden()
        .background(Constants.bgColor)
        .safeAreaInset(edge: .top) {
            headerView
        }
    }

    var headerView: some View {
        HStack(spacing: 16) {
            Image(.arrowLeft)
                .frame(width: 24, height: 24)

            HStack(spacing: 9) {
                Image(.person)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 24, height: 24)
                    .padding(10)
                    .background(.ultraThinMaterial, in: .circle)

                VStack(alignment: .leading, spacing: 3) {
                    Text(viewModel.snippet.channelTitle)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Constants.primaryTextColor)

                    Text(viewModel.snippet.publishedAt)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Constants.secondaryTextColor)
                }
            }

            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom)
        .background(Constants.bgColor)
    }

    @ViewBuilder
    var titleView: some View {
        if let title = viewModel.snippet.title {
            Group {
                if viewModel.isEditing {
                    titleEditingContainer
                } else {
                    Text(title)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Constants.primaryTextColor)
                }
            }
            .padding(.bottom, 12)
        }
    }

    var snippetPreviewImageView: some View {
        VKPreviewImageView(imageState: viewModel.snippet.previewImageState)
    }

    @ViewBuilder
    var descriptionView: some View {
        if let description = viewModel.snippet.description {
            Group {
                if viewModel.isEditing {
                    descriptionEditingContainer
                } else {
                    Text(description)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Constants.primaryTextColor)
                }
            }
            .padding(.top, 26)
        }
    }

    var buttonsConstainer: some View {
        HStack {
            if viewModel.isEditing {
                VKButton(
                    configuration: .basic(
                        title: "Cancel",
                        kind: .medium,
                        style: .inline
                    ),
                    action: viewModel.didTapCancelButton
                )
                .frame(width: 80)
            }
            Spacer()
            VKButton(
                configuration: .basic(
                    title: viewModel.buttonTitle,
                    kind: .medium,
                    style: .primary
                ),
                action: viewModel.didTapEditButton
            )
            .frame(width: 80)
        }
        .padding(.top)
    }

    var titleEditingContainer: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(Constants.title)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Constants.textSecondaryColor)

            LimitedTextField(
                configuration: .init(
                    limit: Constants.titleLimit,
                    tint: .primary,
                    autoResizes: true
                ),
                hint: Constants.inputPlaceholder,
                value: $viewModel.inputTitle
            )
        }
    }

    var descriptionEditingContainer: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(Constants.descriptionTitle)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Constants.textSecondaryColor)

            LimitedTextField(
                configuration: .init(
                    limit: Constants.descriptionLimit,
                    tint: .primary,
                    autoResizes: true,
                    progressConfig: .init(showsRing: false, showsText: true)
                ),
                hint: Constants.inputPlaceholder,
                value: $viewModel.inputDescription
            )
        }
    }
}

// MARK: - Preview

#Preview("Mockable") {
    NavigationStack {
        SnippetDetailView(
            viewModel: SnippetDetailViewModel(snippet: .mockData)
        )
    }
}

// MARK: - Constants

private extension SnippetDetailView {

    enum Constants {
        static let bgColor = VKColor<BackgroundPalette>.bgLightCharcoal.color
        static let primaryTextColor = VKColor<TextPalette>.primary.color
        static let secondaryTextColor = VKColor<TextPalette>.secondary.color
        static let textSecondaryColor = VKColor<TextPalette>.secondary.color
        static let title = "Snippet title"
        static let descriptionTitle = "Snippet description"
        static let inputPlaceholder = "Message..."
        static let titleLimit = 80
        static let descriptionLimit = 160
    }
}
