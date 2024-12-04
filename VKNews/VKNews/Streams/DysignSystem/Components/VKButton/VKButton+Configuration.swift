//
//  VKButton+Configuration.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import SwiftUI

extension VKButton {

    struct Configuration {
        /// Заголовок кнопки
        let title: String
        /// Цвет заднего фона кнопки
        let backgroundColor: Color
        /// Цвет рамки
        let borderColor: Color?
        /// Цвет заднего фона при нажатии на кнопку
        let selectedBackgroundColor: Color
        /// Цвет шрифта кнопки
        let foregroundColor: Color
        /// Высота кнопки
        let buttonHeight: CGFloat
        /// Велечина угла кнопки
        let cornerRadius: CGFloat
        /// Ширина рамки кнопки
        let borderWidth: CGFloat?
    }
}

// MARK: - Kind

extension VKButton.Configuration {

    /// Вид кнопки
    enum Kind {
        case small
        case medium
        case large
    }
}

extension VKButton.Configuration.Kind {

    var buttonHeight: CGFloat {
        switch self {
        case .small:
            return 30
        case .medium:
            return 36
        case .large:
            return 44
        }
    }
}

// MARK: - ButtonStyle

extension VKButton.Configuration {
    
    /// Стиль кнопки
    enum ButtonStyle {
        case primary
        case inline
    }
}

extension VKButton.Configuration.ButtonStyle {

    /// Цвет заднего фона кнопки
    var backgroundColor: Color {
        switch self {
        case .primary:
            return VKColor<BackgroundPalette>.bgButton.color
        case .inline:
            return .clear
        }
    }

    /// Цвет заднего фона при нажатии на кнопку
    var selectedBackgroundColor: Color {
        switch self {
        case .primary:
            return .blue
        case .inline:
            return .gray
        }
    }

    /// Цвет шрифта кнопки
    var foregroundColor: Color {
        switch self {
        case .primary:
            return VKColor<TextPalette>.primaryInverte.color
        case .inline:
            return .primary
        }
    }

    /// Цвет границы кнопки
    var borderColor: Color? {
        switch self {
        case .primary:
            return nil
        case .inline:
            return VKColor<SeparatorPalette>.inlineButton.color
        }
    }

    /// Ширина границы кнопки
    var borderWidth: CGFloat? {
        switch self {
        case .primary:
            return nil
        case .inline:
            return 1
        }
    }
}
