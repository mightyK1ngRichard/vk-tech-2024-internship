//
//  VKTabView.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import SwiftUI

struct VKTabView: View {
    let title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.system(size: 15, weight: .regular))
        }
        .buttonStyle(VKTabViewStyle(isSelected: isSelected))
    }
}

// MARK: - VKTabViewStyle

private struct VKTabViewStyle: ButtonStyle {
    func selectedColor(isPressed: Bool) -> Color {
        isPressed
            ? VKColor<BackgroundPalette>.bgPressedPurple.color
            : VKColor<BackgroundPalette>.bgPurple.color
    }
    func unselectedColor(isPressed: Bool) -> Color {
        isPressed
            ? VKColor<BackgroundPalette>.bgPressedGray.color
            : VKColor<BackgroundPalette>.bgGray.color
    }
    var isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(
                isSelected
                    ? selectedColor(isPressed: configuration.isPressed)
                    : unselectedColor(isPressed: configuration.isPressed),
                in: .rect(cornerRadius: 12)
            )
    }
}

// MARK: - Preview

#Preview {
    struct TabPreview: View {
        @State private var selected = false

        var body: some View {
            VKTabView(title: "Test text", isSelected: selected) {
                selected.toggle()
            }
            .frame(width: 200, height: 200)
            .background(.bar)
        }
    }
    return TabPreview()
}
