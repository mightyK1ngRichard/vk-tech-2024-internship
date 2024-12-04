//
//  EditSnippetView.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import SwiftUI

struct EditSnippetView: View {

    @State private var inputTitle = ""
    @State private var inputDescription = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            titleContainer
            descriptionContainer
        }
    }
}

// MARK: - UI Subviews

private extension EditSnippetView {

    var titleContainer: some View {
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
                value: $inputTitle
            )
        }
    }

    var descriptionContainer: some View {
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
                value: $inputDescription
            )
        }
    }
}

// MARK: - Preview

#Preview {
    EditSnippetView()
        .background(.bar)
        .padding(.horizontal)
}

// MARK: - Constants

private extension EditSnippetView {

    enum Constants {
        static let textSecondaryColor = VKColor<TextPalette>.secondary.color
        static let title = "Snippet title"
        static let descriptionTitle = "Snippet description"
        static let inputPlaceholder = "Message..."
        static let titleLimit = 80
        static let descriptionLimit = 160
    }
}
