//
//  VKButton.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import SwiftUI

struct VKButton: View {
    private let configuration: VKButton.Configuration
    private var action: (() -> Void)?

    init(
        configuration: VKButton.Configuration,
        action: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.action = action
    }

    var body: some View {
        Button(configuration.title) {
            action?()
        }
        .buttonStyle(VKButtonStyle(buttonConfiguration: configuration))
    }
}

// MARK: - VKButton

private struct VKButtonStyle: ButtonStyle {
    let buttonConfiguration: VKButton.Configuration

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .medium))
            .frame(height: buttonConfiguration.buttonHeight)
            .frame(maxWidth: .infinity)
            .background(
                configuration.isPressed
                    ? buttonConfiguration.selectedBackgroundColor
                    : buttonConfiguration.backgroundColor
            )
            .foregroundStyle(buttonConfiguration.foregroundColor)
            .clipShape(.rect(cornerRadius: buttonConfiguration.cornerRadius))
            .contentShape(.rect)
            .overlay {
                if let borderWidth = buttonConfiguration.borderWidth,
                    let borderColor = buttonConfiguration.borderColor {
                    RoundedRectangle(cornerRadius: buttonConfiguration.cornerRadius)
                        .stroke(lineWidth: borderWidth)
                        .fill(borderColor)
                }
            }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        VKButton(
            configuration: .basic(
                title: "Заголовок primary",
                kind: .medium,
                style: .primary
            )
        )

        VKButton(
            configuration: .basic(
                title: "Заголовок inline",
                kind: .large,
                style: .inline
            )
        )
    }
    .padding(.horizontal)
}
