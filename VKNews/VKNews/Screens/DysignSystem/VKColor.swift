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

// MARK: - TextPalette

extension VKColor where Palette == TextPalette {

    static var primary = VKColor(hexLight: 0x000000, hexDark: 0xFEFEFE)
    static var secondary = VKColor(uiColor: .secondaryLabel)
}

// MARK: - BackgroundPalette

extension VKColor where Palette == BackgroundPalette {

    static var bgLightCharcoal = VKColor(hexLight: 0xFFFFFF, hexDark: 0x202020)
}
