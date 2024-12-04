//
//  YouTubeListRouter.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import Observation

protocol YouTubeListRouterProtocol: AnyObject {
    func openSnippetCard(with snippet: YouTubeSnippetModel)
    func setCoordinator(with coordinator: Coordinator)
}

@Observable
final class YouTubeListRouter: YouTubeListRouterProtocol {

    private var coordinator: Coordinator?

    func openSnippetCard(with snippet: YouTubeSnippetModel) {
        guard let coordinator else {
            Logger.log(kind: .error, message: "coordinator is nil")
            return
        }
        coordinator.addScreen(screen: Screens.snippetCard(snippet: snippet))
    }

    func setCoordinator(with coordinator: Coordinator) {
        guard self.coordinator == nil else { return }
        self.coordinator = coordinator
    }
}

// MARK: - Screens

extension YouTubeListRouter {

    enum Screens: Hashable {
        case snippetCard(snippet: YouTubeSnippetModel)
    }
}
