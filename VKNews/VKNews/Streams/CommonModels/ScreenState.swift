//
//  ScreenState.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 05.12.2024.
//

import Foundation

enum ScreenState {
    case initial
    case loading
    case error(String)
    case emptyView
    case success
}
