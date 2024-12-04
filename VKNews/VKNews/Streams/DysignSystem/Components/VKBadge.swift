//
//  VKBadge.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import SwiftUI

struct VKBadge: View {
    let text: String

    var body: some View {
        HStack {
            Image(systemName: "square.and.arrow.down")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
                .foregroundStyle(VKColor<SeparatorPalette>.green.color)
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(VKColor<TextPalette>.green.color)
                .padding([.top, .trailing], 4)
        }
        .padding(.horizontal, 10)
        .padding(.top, 2)
        .padding(.bottom, 5)
        .background(
            VKColor<BackgroundPalette>.bgGreen.color,
            in: .rect(cornerRadius: 8)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .fill(VKColor<SeparatorPalette>.green.color)
        }
    }
}

#Preview {
    VKBadge(text: "Saved")
}
