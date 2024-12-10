//
//  FPSLabel.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 10.12.2024.
//

import SwiftUI

struct FPSLabel: View {
    let currentFPS: Int

    var body: some View {
        HStack {
            Text("Current FPS:")
                .font(.caption)
            Text(String(currentFPS))
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(currentFPS >= 50 ? .green : .red)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
    }
}

// MARK: - Preview

#Preview {
    FPSLabel(currentFPS: 60)
}
