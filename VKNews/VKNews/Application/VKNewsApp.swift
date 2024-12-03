//
//  VKNewsApp.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import SwiftUI

@main
struct VKNewsApp: App {
    var body: some Scene {
        WindowGroup {
            NewsListView(viewModel: NewsListAssembly.shared.build())
        }
    }
}
