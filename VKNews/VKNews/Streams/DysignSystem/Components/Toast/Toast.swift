//
//  Toast.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import SwiftUI

@Observable
final class Toast {
    static let shared = Toast()
    private(set) var toasts: [ToastItem] = []

    private init() {}

    func present(
        title: String,
        icon: ToastIcon = .error,
        tint: Color = .primary,
        timing: ToastTime = .long
    ) {
        withAnimation {
            toasts.append(
                ToastItem(title: title, icon: icon, tint: tint, timing: timing)
            )
        }
    }

    func remove(_ id: UUID) {
        guard
            let index = toasts.firstIndex(where: { $0.id == id })
        else { return }
        toasts.remove(at: index)
    }
}
