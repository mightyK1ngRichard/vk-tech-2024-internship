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
    @State private var fpsMonitor = FPSMonitor()

    init() {
        Logger.log(message: URL.applicationSupportDirectory.path(percentEncoded: false))
    }

    var body: some Scene {
        WindowGroup {
            RootView {
                YouTubeListView(viewModel: YouTubeListAssembly.shared.build())
            }
            .overlay(alignment: .bottomLeading) {
                FPSLabel(currentFPS: fpsMonitor.fps).padding()
            }
        }
        .modelContainer(for: SDYouTubeSnippetModel.self)
    }
}
