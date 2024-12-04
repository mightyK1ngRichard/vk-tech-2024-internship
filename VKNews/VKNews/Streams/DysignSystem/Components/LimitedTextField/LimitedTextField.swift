//
//  LimitedTextField.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import SwiftUI

struct LimitedTextField: View {
    var configuration: Configuration
    var hint: String
    @Binding var value: String
    @FocusState private var isKeyboardShowing: Bool
    var onSubmit: (() -> Void)?

    var body: some View {
        VStack(alignment: configuration.progressConfig.alignment, spacing: 12) {
            ZStack(alignment: .top) {
                tappedView
                textFieldView
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: configuration.borderConfig.radius)
                    .stroke(progressColor.gradient, lineWidth: configuration.borderConfig.width)
            }

            progressBar
        }
    }

    // MARK: Calculated Values

    private var progress: CGFloat {
        max(min(CGFloat(value.count) / CGFloat(configuration.limit), 1), 0)
    }

    private var progressColor: Color {
        progress < 0.6 ? configuration.tint : progress == 1 ? .red : .orange
    }
}

// MARK: - UI Subviews

private extension LimitedTextField {

    var tappedView: some View {
        RoundedRectangle(cornerRadius: configuration.borderConfig.radius)
            .fill(.clear)
            .frame(height: configuration.autoResizes ? 0 : nil)
            .contentShape(.rect(cornerRadius: configuration.borderConfig.radius))
            .onTapGesture {
                isKeyboardShowing = true
            }
    }

    var textFieldView: some View {
        TextField(hint, text: $value, axis: .vertical)
            .focused($isKeyboardShowing)
            .onChange(of: value, initial: true) { oldValue, newValue in
                guard !configuration.allowsExcessTyping else { return }
                value = String(value.prefix(configuration.limit))
            }
            .onSubmit {
                onSubmit?()
            }
            .submitLabel(configuration.submitLabel)
    }

    var progressBar: some View {
        HStack(alignment: .top, spacing: 12) {
            if configuration.progressConfig.showsRing {
                ZStack {
                    Circle()
                        .stroke(.ultraThinMaterial, lineWidth: 5)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(progressColor.gradient, lineWidth: 5)
                        .rotationEffect(.degrees(-90))
                }
                .frame(width: 20, height: 20)
            }

            if configuration.progressConfig.showsText {
                Text("\(value.count)/\(configuration.limit)")
                    .foregroundStyle(progressColor.gradient)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    struct LimitedTextFieldPreview: View {
        @State private var text = ""

        var body: some View {
            Group {
                LimitedTextField(
                    configuration: .init(limit: 80, tint: .secondary, autoResizes: true),
                    hint: "Type here",
                    value: $text
                )

                LimitedTextField(
                    configuration: .init(
                        limit: 80,
                        tint: .secondary,
                        autoResizes: true,
                        progressConfig: .init(showsRing: false, showsText: true)
                    ),
                    hint: "Type here",
                    value: $text
                )
            }
            .frame(maxHeight: 150)
            .padding(.horizontal)
        }
    }

    return LimitedTextFieldPreview()
}
