//
//  VKColor.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import UIKit
import SwiftUI

final class VKColor<Palette: Hashable> {
    let color: Color
    let uiColor: UIColor

    init(hexLight: Int, hexDark: Int, alphaLight: CGFloat = 1.0, alphaDark: CGFloat = 1.0) {
        let lightColor = UIColor(hex: hexLight, alpha: alphaLight)
        let darkColor = UIColor(hex: hexDark, alpha: alphaDark)
        let uiColor = UIColor { $0.userInterfaceStyle == .light ? lightColor : darkColor }
        self.uiColor = uiColor
        self.color = Color(uiColor: uiColor)
    }

    init(hexLight: Int, hexDark: Int, alpha: CGFloat = 1.0) {
        let chmColor = VKColor(hexLight: hexLight, hexDark: hexDark, alphaLight: alpha, alphaDark: alpha)
        self.uiColor = chmColor.uiColor
        self.color = chmColor.color
    }

    init(uiColor: UIColor) {
        self.uiColor = uiColor
        self.color = Color(uiColor: uiColor)
    }
}

// MARK: - Palettes

enum TextPalette: Hashable {}
enum BackgroundPalette: Hashable {}
enum SeparatorPalette: Hashable {}

// MARK: - TextPalette

extension VKColor where Palette == TextPalette {

    static let primary = VKColor(hexLight: 0x000000, hexDark: 0xFEFEFE)
    static let primaryInverte = VKColor(hexLight: 0xFFFFFF, hexDark: 0x2C2D2E)
    static let secondary = VKColor(uiColor: .secondaryLabel)
    static let green = VKColor(hexLight: 0x1DAF66, hexDark: 0x1DCB74)
}

// MARK: - BackgroundPalette

extension VKColor where Palette == BackgroundPalette {
    
    /// Светлое тёмное
    static let bgLightCharcoal = VKColor(hexLight: 0xFFFFFF, hexDark: 0x202020)
    /// Цвет фона кнопки
    static let bgButton = VKColor(hexLight: 0x2D81E0, hexDark: 0xFFFFFF)
    /// Цвет шиммера
    static let bgShimmering = VKColor(hexLight: 0xF3F3F7, hexDark: 0x242429)
    /// Цвет фона бейджа
    static let bgGreen = VKColor(hexLight: 0xE4F8EE, hexDark: 0x203C2E)
    static let bgPurple = VKColor(hexLight: 0xF2E6FE, hexDark: 0x3A2D53)
    static let bgPressedPurple = VKColor(hexLight: 0xD3B6FB, hexDark: 0x4F416D)
    static let bgGray = VKColor(hexLight: 0xFFFFFF, hexDark: 0x242429)
    static let bgPressedGray = VKColor(hexLight: 0xD1D1E0, hexDark: 0x3B3B44)
}

// MARK: - SeparatorPalette

extension VKColor where Palette == SeparatorPalette {

    static let primaryInverse = VKColor(hexLight: 0xFEFEFE, hexDark: 0x000000)
    static let inlineButton = VKColor(hexLight: 0x2688EB, hexDark: 0xFFFFFF)
    static let green = VKColor(hexLight: 0x049C6B, hexDark: 0x049C6B)
}
