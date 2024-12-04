//
//  YouTubeListViewModel.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation
import Observation
import SwiftData

protocol YouTubeListViewModelProtocol: AnyObject {
    // Values
    var snippets: [YouTubeSnippetModel] { get }
    var errorMessage: String? { get }
    var showLoading: Bool { get }
    var showMoreLoading: Bool { get }
    // Network
    func onAppear()
    func fetchData()
    func loadMoreData(with snippet: YouTubeSnippetModel)
    // Display Data
    func showSnippets(_ data: [YouTubeSnippetModel], nextPageToken: String?)
    func addSnippetsFromMemory(_ data: [YouTubeSnippetModel])
    func showError(errorMessage: String)
    func insertImageInSnippet(snippetID: String, imageData: Data)
    // Setters
    func setModelContext(modelContext: ModelContext)
    func setCoordinator(with coordinator: Coordinator)
    func didEditSnippet(snippet: YouTubeSnippetModel)
    // Actions
    func didTapSnippetCard(snippet: YouTubeSnippetModel)
}

// MARK: - YouTubeListViewModel

@Observable
final class YouTubeListViewModel: YouTubeListViewModelProtocol {
    @ObservationIgnored
    var interactor: YouTubeListInteractorProtocol?
    @ObservationIgnored
    var router: YouTubeListRouterProtocol?

    /// Фрагменты видео
    private(set) var snippets: [YouTubeSnippetModel]
    /// Флаг показа стартовой загрузки
    private(set) var showLoading: Bool
    /// Флаг показа индикатора загрузки при бесконечном скролле
    private(set) var showMoreLoading: Bool
    /// Текст ошибки
    private(set) var errorMessage: String?
    /// Флаг провекри, доставали ли мы уже данные из памяти
    private(set) var didLoadMemoryData = false

    /// Токен для следующей пагинации
    @ObservationIgnored
    private var nextPageToken: String?
    /// Последний показанный открывок на экране
    @ObservationIgnored
    private var lastSnippet: YouTubeSnippetModel?

    init(
        interactor: YouTubeListInteractorProtocol? = nil,
        router: YouTubeListRouterProtocol? = nil,
        snippets: [YouTubeSnippetModel] = [],
        showLoading: Bool = false,
        showMoreLoading: Bool = false,
        errorMessage: String? = nil
    ) {
        self.interactor = interactor
        self.router = router
        self.snippets = snippets
        self.showLoading = showLoading
        self.showMoreLoading = showMoreLoading
        self.errorMessage = errorMessage
    }
}

// MARK: - Network

extension YouTubeListViewModel {

    func onAppear() {
        // Если последний сниппет и токен == nil, значит это первый запрос и показываем лоудер
        guard lastSnippet == nil && nextPageToken == nil else {
            return
        }
        showLoading = true

        // Достаём данные из памяти устройства, если ещё этого не делали
        if !didLoadMemoryData {
            interactor?.fetchMemorySnippets()
            didLoadMemoryData = true
        }
        fetchData()
    }

    func fetchData() {
        let request = YouTubeSearchServiceRequest(
            apiKey: "AIzaSyCoodvTpxCnw1CA5PpuHMMiAyqConzXkSc",
            query: "christmas",
            maxResults: "10",
            pageToken: nextPageToken
        )
        interactor?.fetchSnippets(req: request)
    }

    func loadMoreData(with snippet: YouTubeSnippetModel) {
        guard snippet.id == lastSnippet?.id else { return }
        showMoreLoading = true
        fetchData()
    }
}

// MARK: - Display Data

extension YouTubeListViewModel {

    func showSnippets(_ data: [YouTubeSnippetModel], nextPageToken: String?) {
        DispatchQueue.main.async {
            self.mergeSnippets(newSnippets: data)
            self.nextPageToken = nextPageToken
            self.lastSnippet = data.last
            self.showLoading = false
            self.showMoreLoading = false
        }
    }

    func addSnippetsFromMemory(_ data: [YouTubeSnippetModel]) {
        mergeSnippets(newSnippets: data)
        showLoading = false
        lastSnippet = data.last
    }

    func showError(errorMessage: String) {
        DispatchQueue.main.async {
            self.errorMessage = errorMessage
        }
    }

    func insertImageInSnippet(snippetID: String, imageData: Data) {
        guard let index = snippets.firstIndex(where: { $0.id == snippetID }) else {
            return
        }
        DispatchQueue.main.async {
            self.snippets[index].previewImageState = .data(imageData)
            // Обновляем изображение в хранилище
            self.interactor?.insertImageInSnippet(snippetID: self.snippets[index].id, imageData: imageData)
        }
    }

    /// Добавляем уникальные сниппеты в конец массива
    /// - Parameter newSnippets: Новые сниппеты
    private func mergeSnippets(newSnippets: [YouTubeSnippetModel]) {
        var seen = Set(snippets)
        let uniqueSnippets = newSnippets.filter { seen.insert($0).inserted }
        snippets.append(contentsOf: uniqueSnippets)
    }
}

// MARK: - Actions

extension YouTubeListViewModel {

    func didTapSnippetCard(snippet: YouTubeSnippetModel) {
        router?.openSnippetCard(with: snippet)
    }
}

// MARK: - Setter

extension YouTubeListViewModel {

    func setModelContext(modelContext: ModelContext)  {
        interactor?.setModelContext(modelContext: modelContext)
    }

    func setCoordinator(with coordinator: Coordinator) {
        router?.setCoordinator(with: coordinator)
    }

    func didEditSnippet(snippet: YouTubeSnippetModel) {
        guard
            let index = snippets.firstIndex(where: { $0.id == snippet.id })
        else {
            Logger.log(kind: .error, message: "Отредактированный сниппет id=\(snippet.id) не найден в массиве")
            return
        }
        snippets[index] = snippet
    }
}
