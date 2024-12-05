//
//  UINavigationController+Extensions.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import UIKit

extension UINavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
