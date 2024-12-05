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
    var screenState: ScreenState { get }
    var showMoreLoading: Bool { get }
    var orderMode: SnippetSortingMode { get set }
    // Network
    func onAppear()
    func fetchData()
    func loadMoreData(with snippet: YouTubeSnippetModel)
    // Display Data
    func showSnippets(_ data: [YouTubeSnippetModel], nextPageToken: String?)
    func addSnippetsFromMemory(_ data: [YouTubeSnippetModel])
    func showError(errorMessage: String)
    func insertImageInSnippet(snippetID: String, imageResult: Result<Data, Error>)
    // Setters
    func setModelContext(modelContext: ModelContext)
    func setCoordinator(with coordinator: Coordinator)
    func didEditSnippet(snippet: YouTubeSnippetModel)
    // Actions
    func didTapSnippetCard(snippet: YouTubeSnippetModel)
    func deleteSnippet(snippet: YouTubeSnippetModel)
    func didDeletedSuccessfully()
}

// MARK: - YouTubeListViewModel

@Observable
final class YouTubeListViewModel: YouTubeListViewModelProtocol {
    @ObservationIgnored
    var interactor: YouTubeListInteractorProtocol?
    @ObservationIgnored
    var router: YouTubeListRouterProtocol?
    
    /// Режим сортировки
    var orderMode: SnippetSortingMode {
        didSet {
            guard oldValue != orderMode else { return }
            insertNetworkDataIntoStart = true
            fetchData()
        }
    }
    /// Фрагменты видео
    private(set) var snippets: [YouTubeSnippetModel]
    /// Состояние экрана
    private(set) var screenState: ScreenState
    /// Флаг показа индикатора загрузки при бесконечном скролле
    private(set) var showMoreLoading: Bool
    /// Текст ошибки
    private(set) var errorMessage: String?
    /// Флаг провекри, доставали ли мы уже данные из памяти
    private(set) var didLoadMemoryData = false

    
    /// Флаг, сообщающий куда добавлять новые данные. В начало или конец
    @ObservationIgnored
    private var insertNetworkDataIntoStart = false
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
        orderMode: SnippetSortingMode = .relevance,
        screenState: ScreenState = .initial,
        showMoreLoading: Bool = false,
        errorMessage: String? = nil
    ) {
        self.orderMode = orderMode
        self.interactor = interactor
        self.router = router
        self.snippets = snippets
        self.screenState = screenState
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
        insertNetworkDataIntoStart = true
        screenState = .loading

        // Достаём данные из памяти устройства, если ещё этого не делали
        if !didLoadMemoryData {
            interactor?.fetchMemorySnippets()
            didLoadMemoryData = true
        }

        fetchData()
    }

    func fetchData() {
        let request = YouTubeSearchServiceRequest(
            apiKey: "AIzaSyBwvqnXYz9c89ZMc12kpojT1qpf_FmYNkA",
            query: "christmas",
            maxResults: "10",
            pageToken: nextPageToken,
            order: orderMode.rawValue
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
            self.mergeSnippets(newSnippets: data, addToEnd: !self.insertNetworkDataIntoStart)
            self.lastSnippet = self.snippets.last
            self.insertNetworkDataIntoStart = false
            self.nextPageToken = nextPageToken
            self.screenState = self.snippets.isEmpty ? .emptyView : .success
            self.showMoreLoading = false
        }
    }

    func addSnippetsFromMemory(_ data: [YouTubeSnippetModel]) {
        mergeSnippets(newSnippets: data, addToEnd: true)
        screenState = .success
        lastSnippet = snippets.last
    }

    func showError(errorMessage: String) {
        DispatchQueue.main.async {
            self.errorMessage = errorMessage
            Toast.shared.present(title: errorMessage)
            self.showMoreLoading = false
            self.screenState = self.snippets.isEmpty ? .error(errorMessage) : .success
        }
    }

    func didDeletedSuccessfully() {
        Toast.shared.present(title: "Successfully deleted", icon: .checkmark, tint: VKColor<TextPalette>.green.color)
    }

    func insertImageInSnippet(snippetID: String, imageResult: Result<Data, Error>) {
        guard let index = snippets.firstIndex(where: { $0.id == snippetID }) else {
            Logger.log(kind: .error, message: "snippetID=\(snippetID) not found")
            return
        }
        DispatchQueue.main.async {
            switch imageResult {
            case let.success(imageData):
                self.snippets[index].previewImageState = .data(imageData)
                self.interactor?.insertImageInSnippet(snippetID: self.snippets[index].id, imageData: imageData)
            case let .failure(errorMessage):
                // Также тут можно прокидывать детали ошибки
                self.snippets[index].previewImageState = .none
                Logger.log(kind: .error, message: errorMessage)
            }
        }
    }

    /// Добавляем уникальные сниппеты в конец массива
    /// - Parameter newSnippets: Новые сниппеты
    private func mergeSnippets(newSnippets: [YouTubeSnippetModel], addToEnd: Bool) {
        var seen = Set(snippets)
        let uniqueSnippets = newSnippets.filter { seen.insert($0).inserted }
        if addToEnd {
            snippets.append(contentsOf: uniqueSnippets)
        } else {
            snippets.insert(contentsOf: uniqueSnippets, at: 0)
        }
    }
}

// MARK: - Actions

extension YouTubeListViewModel {

    func didTapSnippetCard(snippet: YouTubeSnippetModel) {
        router?.openSnippetCard(with: snippet)
    }

    func deleteSnippet(snippet: YouTubeSnippetModel) {
        guard let index = (snippets.firstIndex { $0.id == snippet.id }) else {
            return
        }
        snippets.remove(at: index)
        interactor?.deleteSnippetFromMemory(snippet: snippet)
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
