//
//  HeaderSectionView.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import SwiftUI

struct HeaderSectionView<Cells>: View where Cells: Hashable {
    let cells: [Cells]
    @Binding var lastSelectedItem: Cells

    var body: some View {
        tabsView
    }
}

// MARK: - UI Subviews

private extension HeaderSectionView {

    var tabsView: some View {
        ScrollView(.horizontal) {
            ScrollViewReader { scrollViewProxy in
                scrollCells
                    .padding(.horizontal)
                    .onChange(of: lastSelectedItem) { _, newValue in
                        withAnimation {
                            scrollViewProxy.scrollTo(newValue, anchor: .center)
                        }
                    }
            }
        }
        .scrollIndicators(.hidden)
    }

    var scrollCells: some View {
        HStack {
            ForEach(cells, id: \.self) { cell in
                VKTabView(
                    title: "\(cell)".capitalized,
                    isSelected: cell == lastSelectedItem
                ) {
                    lastSelectedItem = cell
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    struct HeaderSectionPreview: View {
        @State var lastSelectedItem: String = "Date"

        var body: some View {
            VStack {
                Text("selected: \(lastSelectedItem)")
                HeaderSectionView(cells: ["Date", "Time"], lastSelectedItem: $lastSelectedItem)
                    .padding()
                    .background(.bar)
            }
        }
    }

    return HeaderSectionPreview()
}
