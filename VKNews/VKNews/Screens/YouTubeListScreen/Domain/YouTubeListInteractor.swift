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
    // Network
    func fetchSnippets(req: YouTubeSearchServiceRequest)
    // Memory
    func setModelContext(modelContext: ModelContext)
    func saveOnDeviceMemory(entities: [YouTubeSearchItemEntity]) throws
    func insertImageInSnippet(snippetID: String, imageData: Data)
}

// MARK: - YouTubeListInteractor

final class YouTubeListInteractor: YouTubeListInteractorProtocol {

    var presenter: YouTubeListPresenterProtocol?
    private let youTubeService: YouTubeSearchServiceProtocol
    private let imageLoaderService: ImageLoaderServiceProtocol
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

                // Получаем изображения снипетов
                let stream = try await startLoadingImages(response.items)
                for try await (snippetID, imageData) in stream {
                    presenter?.addImageIntoSnippet(snippetID: snippetID, imageData: imageData)
                }

                // Кэшируем
                do {
                    try saveOnDeviceMemory(entities: response.items)
                } catch {
                    Logger.log(kind: .error, message: error.localizedDescription)
                }
            } catch {
                Logger.log(kind: .error, message: error)
                presenter?.presentError(error: error)
                imagesLoadingTask = nil
            }
        }
    }
    
    /// Записываем сниппет в хранилище устройства без изображения
    /// - Parameter entities: Сетевые данные о сниппете
    func saveOnDeviceMemory(entities: [YouTubeSearchItemEntity]) throws {
        guard let modelContext else { throw InteractorError.noContextModel }

        for entity in entities {
            guard let id = entity.id.videoId else { continue }
            let model = SDYouTubeSnippetModel(
                id: id,
                title: entity.snippet.title,
                description: entity.snippet.description,
                // Изображение будем кэщировать при его получении
                previewImageData: nil,
                publishedAt: entity.snippet.publishedAt,
                channelTitle: entity.snippet.channelTitle
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
    ) async throws -> AsyncThrowingStream<(id: String, imageData: Data), Error> {
        let imagesWithIDs: [(id: String, url: URL)] = snippets.compactMap {
            guard
                let id = $0.id.videoId,
                let url = URL(string: $0.snippet.thumbnails.high.url)
            else {
                Logger.log(kind: .error, message: "Для \($0.snippet.title) не найден ID")
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
    }
}
