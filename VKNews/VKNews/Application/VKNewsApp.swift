//
//  VKNewsApp.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import SwiftUI
import SwiftData

@main
struct VKNewsApp: App {
    init() {
        Logger.log(message: URL.applicationSupportDirectory.path(percentEncoded: false))
    }

    var body: some Scene {
        WindowGroup {
            YouTubeListView(viewModel: YouTubeListAssembly.shared.build())
        }
        .modelContainer(for: SDYouTubeSnippetModel.self)
    }
}
