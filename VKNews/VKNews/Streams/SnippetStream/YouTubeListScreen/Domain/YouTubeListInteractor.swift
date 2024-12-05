//
//  YouTubeListInteractor.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation
import UIKit
import SwiftData

protocol YouTubeListInteractorProtocol: AnyObject {
    // Values
    var youTubeService: YouTubeSearchServiceProtocol { get }
    var imageLoaderService: ImageLoaderServiceProtocol { get }
    var presenter: YouTubeListPresenterProtocol? { get set }
    // Network
    func fetchSnippets(req: YouTubeSearchServiceRequest)
    // Memory
    func setModelContext(modelContext: ModelContext)
    func fetchMemorySnippets()
    func saveOnDeviceMemory(entities: [YouTubeSearchItemEntity]) throws
    func insertImageInSnippet(snippetID: String, imageData: Data)
    func deleteSnippetFromMemory(snippet: YouTubeSnippetModel)
}

// MARK: - YouTubeListInteractor

final class YouTubeListInteractor: YouTubeListInteractorProtocol {

    var presenter: YouTubeListPresenterProtocol?
    let youTubeService: YouTubeSearchServiceProtocol
    let imageLoaderService: ImageLoaderServiceProtocol
    private var imagesLoadingTask: Task<Void, Never>?
    private var modelContext: ModelContext?

    init(
        presenter: YouTubeListPresenterProtocol? = nil,
        youTubeService: YouTubeSearchServiceProtocol,
        imageLoaderService: ImageLoaderServiceProtocol
    ) {
        self.presenter = presenter
        self.youTubeService = youTubeService
        self.imageLoaderService = imageLoaderService
    }
}

// MARK: - NewsListInteractorProtocol

extension YouTubeListInteractor {

    func fetchSnippets(req: YouTubeSearchServiceRequest) {
        imagesLoadingTask = Task(priority: .userInitiated) {
            do {
                // Получаем снипеты
                let response = try await getSnippets(req: req)
                presenter?.presentSnippetsList(response: response)

                // Кэшируем
                do {
                    try saveOnDeviceMemory(entities: response.items)
                } catch {
                    Logger.log(kind: .error, message: error.localizedDescription)
                }

                // Получаем изображения снипетов
                let stream = try await startLoadingImages(response.items)
                for try await (snippetID, imageResult) in stream {
                    presenter?.addImageIntoSnippet(snippetID: snippetID, imageResult: imageResult)
                }
            } catch {
                Logger.log(kind: .error, message: error)
                presenter?.presentError(error: error)
                imagesLoadingTask = nil
            }
        }
    }
    
    /// Достаём данные из устройства
    func fetchMemorySnippets() {
        let descriptor = FetchDescriptor<SDYouTubeSnippetModel>()
        guard
            let results = (try? modelContext?.fetch(descriptor)),
            !results.isEmpty
        else {
            return
        }
        presenter?.getSnippetsFromMemory(snippets: results)
    }

    /// Записываем сниппет в хранилище устройства без изображения
    /// - Parameter entities: Сетевые данные о сниппете
    func saveOnDeviceMemory(entities: [YouTubeSearchItemEntity]) throws {
        guard let modelContext else { throw InteractorError.noContextModel }

        for entity in entities {
            guard
                let id = entity.id?.videoId,
                let snippet = entity.snippet
            else { continue }
            let model = SDYouTubeSnippetModel(
                id: id,
                title: snippet.title,
                description: snippet.description,
                // Изображение будем кэщировать при его получении
                previewImageData: nil,
                publishedAt: snippet.publishedAt ?? "",
                channelTitle: snippet.channelTitle ?? ""
            )
            if !model.isSaved(context: modelContext) {
                modelContext.insert(model)
            }
        }

        try modelContext.save()
        Logger.log(message: "Данные сохранены на устройстве")
    }
    
    /// Добавляем изображение к записи сниппета на устройстве
    /// - Parameters:
    ///   - snippetID: ID сниппета
    ///   - imageData: Данные об изображении
    func insertImageInSnippet(snippetID: String, imageData: Data) {
        let predicate = #Predicate<SDYouTubeSnippetModel> { $0._id == snippetID }
        let descriptor = FetchDescriptor(predicate: predicate)
        guard
            let results = try? modelContext?.fetch(descriptor),
            let snippet = results.first
        else {
            Logger.log(kind: .error, message: "snippetID: \(snippetID) не найден в хранилище. Изображение не обновлено")
            return
        }

        snippet._previewImageData = imageData
        try? modelContext?.save()
    }

    func deleteSnippetFromMemory(snippet: YouTubeSnippetModel) {
        let snippetID = snippet.id
        let predicate = #Predicate<SDYouTubeSnippetModel> { $0._id == snippetID }
        let description = FetchDescriptor(predicate: predicate)
        guard
            let results = try? modelContext?.fetch(description),
            let sdSnippet = results.first
        else {
            Logger.log(kind: .error, message: "snippetID: \(snippetID) не найден в хранилище. Сниппет не удаленн")
            presenter?.presentError(error: InteractorError.deleteContextModelError)
            return
        }
        modelContext?.delete(sdSnippet)
        do {
            try modelContext?.save()
            presenter?.didDeletedSuccessfully()
        } catch {
            Logger.log(kind: .error, message: error)
            presenter?.presentError(error: InteractorError.deleteContextModelError)
        }
    }

    func setModelContext(modelContext: ModelContext) {
        guard self.modelContext == nil else { return }
        self.modelContext = modelContext
    }
}

// MARK: - Helpers

private extension YouTubeListInteractor {

    func getSnippets(req: YouTubeSearchServiceRequest) async throws -> YouTubeSearchResponseEntity {
        try await youTubeService.getYouTubeVideos(req: req)
    }

    func startLoadingImages(
        _ snippets: [YouTubeSearchItemEntity]
    ) async throws -> AsyncThrowingStream<(id: String, imageData: Result<Data, Error>), Error> {
        let imagesWithIDs: [(id: String, url: URL)] = snippets.compactMap {
            guard
                let id = $0.id?.videoId,
                let stringURL = $0.snippet?.thumbnails?.high?.url,
                let url = URL(string: stringURL)
            else {
                Logger.log(kind: .error, message: "Для \($0.snippet?.title ?? "no title") не найден ID")
                return nil
            }
            return (id: id, url: url)
        }

        return try await imageLoaderService.loadImages(from: imagesWithIDs)
    }
}

// MARK: - InteractorError

extension YouTubeListInteractor {

    enum InteractorError: Error {
        case noContextModel
        case deleteContextModelError
    }
}
