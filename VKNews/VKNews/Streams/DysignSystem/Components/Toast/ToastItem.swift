//
//  ToastItem.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import Foundation
import SwiftUI

struct ToastItem: Identifiable {
    let id = UUID()
    var title: String
    var icon: ToastIcon = .error
    var tint: Color
    var timing: ToastTime = .medium
}

// MARK: - ToastTime

enum ToastTime: CGFloat {
    case short = 1.0
    case medium = 2.0
    case long = 3.5
}

// MARK: - ToastIcon

enum ToastIcon {
    case noInternet
    case error
    case checkmark
    case custom(systemName: String)
}

extension ToastIcon {

    var image: Image {
        switch self {
        case .noInternet:
            return Image(systemName: "network.slash")
        case .error:
            return Image(systemName: "exclamationmark.triangle")
        case .checkmark:
            return Image(systemName: "checkmark.circle")
        case let .custom(systemName):
            return Image(systemName: systemName)
        }
    }
}
