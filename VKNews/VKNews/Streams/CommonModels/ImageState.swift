//
//  ImageState.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import Foundation

enum ImageState: Hashable, Equatable {
    case loading
    case none
    case data(Data)
}

// MARK: - Equatable

extension ImageState {

    static func == (lhs: ImageState, rhs: ImageState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.none, .none):
            return true
        case let (.data(lhsData), .data(rhsData)):
            return lhsData == rhsData
        default:
            return false
        }
    }
}
