//
//  ImageState.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import UIKit

enum ImageState: Hashable {
    case loading
    case none
    case uiImage(UIImage)
}
