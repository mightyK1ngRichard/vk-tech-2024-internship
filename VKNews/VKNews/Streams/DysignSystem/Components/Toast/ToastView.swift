//
//  ToastView.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import SwiftUI

struct ToastView: View {
    var size: CGSize
    var item: ToastItem
    @State private var delayTask: DispatchWorkItem?

    var body: some View {
        HStack {
            item.icon.image

            Text(item.title)
                .lineLimit(2)
        }
        .foregroundStyle(item.tint)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            .background
                .shadow(.drop(color: .primary.opacity(0.06), radius: 5, x: -5, y: -5))
                .shadow(.drop(color: .primary.opacity(0.06), radius: 8, x: 5, y: 5)),
            in: .capsule
        )
        .contentShape(.capsule)
        .gesture(gesture)
        .onAppear(perform: onAppear)
        .frame(maxWidth: size.width * 0.8)
        .transition(.offset(y: -200))
    }
}

// MARK: - Helpers

extension ToastView {

    var gesture: some Gesture {
        DragGesture(minimumDistance: 0).onEnded { value in
            let endY = value.translation.height
            let velocityY = value.velocity.height

            if (endY - velocityY) > 100 {
                removeToast()
            }
        }
    }

    func removeToast() {
        if let delayTask {
            delayTask.cancel()
        }
        withAnimation(.snappy) {
            Toast.shared.remove(item.id)
        }
    }

    func onAppear() {
        guard delayTask == nil else { return }
        delayTask = DispatchWorkItem {
            removeToast()
        }

        if let delayTask {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + item.timing.rawValue,
                execute: delayTask
            )
        }
    }
}
