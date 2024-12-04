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
