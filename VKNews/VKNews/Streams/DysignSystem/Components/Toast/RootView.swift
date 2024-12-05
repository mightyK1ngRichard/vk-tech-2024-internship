//
//  RootView.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import SwiftUI

/// RootView для создания окна оверлея c уведомлениями
struct RootView<Content: View>: View {
    @ViewBuilder var content: Content
    @State private var overlayWindow: UIWindow?

    var body: some View {
        content.onAppear {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, overlayWindow == nil {
                let window = PathThroughWindow(windowScene: windowScene)
                window.backgroundColor = .clear

                let rootController = UIHostingController(rootView: ToastGroup())
                rootController.view.frame = windowScene.keyWindow?.frame ?? .zero
                rootController.view.backgroundColor = .clear

                window.rootViewController = rootController
                window.isHidden = false
                window.isUserInteractionEnabled = true

                overlayWindow = window
            }
        }
    }

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}

// MARK: - PathThroughWindow

private class PathThroughWindow: UIWindow {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }

        return rootViewController?.view == view ? nil : view
    }
}

// MARK: - ToastGroup

private struct ToastGroup: View {
    var model = Toast.shared
    @Environment(\.colorScheme) private var theme

    var body: some View {
        GeometryReader {
            let size = $0.size
            ZStack {
                ForEach(model.toasts) { toast in
                    ToastView(size: size, item: toast)
                        .scaleEffect(scale(toast))
                        .offset(y: offsetY(toast))
                        .zIndex(Double(model.toasts.firstIndex(where: { $0.id == toast.id }) ?? 0))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .preferredColorScheme(theme)
    }

    func numberInStack(_ item: ToastItem) -> CGFloat {
        let indexOfItem = model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0
        let totalCount = model.toasts.count - 1

        return CGFloat(totalCount - indexOfItem)
    }

    func offsetY(_ item: ToastItem) -> CGFloat {
        numberInStack(item) >= .numberOfVisibleToastBehind ? .offsetY : (numberInStack(item) * 10)
    }

    func scale(_ item: ToastItem) -> CGFloat {
        1.0 - (numberInStack(item) >= .numberOfVisibleToastBehind
            ? .scaleFactorForBackToasts
            : (numberInStack(item) * .scaleFactorForFirstToasts)
        )
    }
}

// MARK: - Constants

private extension CGFloat {

    static let numberOfVisibleToastBehind: CGFloat = 2
    static let offsetY: CGFloat = 20
    static let scaleFactorForBackToasts: CGFloat = 0.2
    static let scaleFactorForFirstToasts: CGFloat = 0.1
}
