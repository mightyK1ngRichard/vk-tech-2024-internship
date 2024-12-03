//
//  Mockable.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

protocol Mockable {
    static var mockData: Self { get }
}
