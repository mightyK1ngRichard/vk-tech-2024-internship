//
//  StartLoadingView.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import SwiftUI

struct SnippetShimmeringView: View {
    var body: some View {
        VStack(alignment: .leading) {
            headerShimmeringView
            contentShimmeringView
        }
    }
}

// MARK: - UI Subviews

private extension SnippetShimmeringView {

    var headerShimmeringView: some View {
        HStack {
            ShimmeringView()
                .frame(width: 42, height: 42)
                .clipShape(.circle)

            VStack(alignment: .leading, spacing: 3) {
                Group {
                    ShimmeringView()
                        .frame(width: 76, height: 16)
                    ShimmeringView()
                        .frame(width: 53, height: 12)
                }
                .clipShape(.capsule)
            }
        }
    }

    var contentShimmeringView: some View {
        VStack {
            textShimmeringView(count: 2)
            ShimmeringView()
                .frame(height: 192)
                .clipShape(.rect(cornerRadius: 8))
            textShimmeringView(count: 3)
        }
    }

    func textShimmeringView(count: Int) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            ForEach(0..<count, id: \.self) { number in
                ShimmeringView()
                    .frame(height: 12)
                    .clipShape(.capsule)
                    .padding(.trailing, CGFloat((count - number - 1) * 20))
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SnippetShimmeringView()
        .padding(.horizontal)
}
