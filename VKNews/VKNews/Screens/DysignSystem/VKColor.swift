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
}

// MARK: - BackgroundPalette

extension VKColor where Palette == BackgroundPalette {
    
    /// Светлое тёмное
    static let bgLightCharcoal = VKColor(hexLight: 0xFFFFFF, hexDark: 0x202020)
    /// Цвет фона кнопки
    static let bgButton = VKColor(hexLight: 0x2D81E0, hexDark: 0xFFFFFF)
    /// Цвет шиммера
    static let bgShimmering = VKColor(hexLight: 0xF3F3F7, hexDark: 0x242429)
}

// MARK: - SeparatorPalette

extension VKColor where Palette == SeparatorPalette {

    static let primaryInverse = VKColor(hexLight: 0xFEFEFE, hexDark: 0x000000)
    static let inlineButton = VKColor(hexLight: 0x2688EB, hexDark: 0xFFFFFF)
}
