//
//  ImageLoaderService.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import Foundation

// MARK: - ImageLoaderProtocol

protocol ImageLoaderServiceProtocol: Sendable {
    func loadImage(from url: URL) async throws -> Data
    func loadImages(from urls: [(id: String, url: URL)]) async throws -> AsyncThrowingStream<(id: String, imageData: Result<Data, Error>), Error>
}

// MARK: - ImageLoaderService

final class ImageLoaderService: ImageLoaderServiceProtocol {
    typealias ImageDataWithID = (id: String, imageData: Result<Data, Error>)

    func loadImage(from url: URL) async throws -> Data {
        let request = URLRequest(url: url, timeoutInterval: 2)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }

    func loadImages(from urls: [(id: String, url: URL)]) async throws -> AsyncThrowingStream<ImageDataWithID, Error> {
        let (stream, continuation) = AsyncThrowingStream<ImageDataWithID, Error>.makeStream()
        let task = Task(priority: .userInitiated) {
            await withTaskGroup(of: ImageDataWithID?.self) { group in
                for (id, url) in urls {
                    group.addTask {
                        do {
                            guard !Task.isCancelled else {
                                Logger.log(message: "task has been canceled")
                                return (id: id, imageData: .failure(CancellationError()))
                            }
                            let imageData = try await self.loadImage(from: url)
                            return (id: id, imageData: .success(imageData))
                        } catch {
                            Logger.log(kind: .error, message: error)
                            return (id: id, imageData: .failure(error))
                        }
                    }
                }

                var hasImages = false
                for await result in group {
                    guard let result else {
                        Logger.log(message: "result is nil")
                        continue
                    }
                    continuation.yield(result)
                    hasImages = true
                }

                guard hasImages else {
                    continuation.finish(throwing: ImageLoaderError.emptyResult)
                    Logger.log(message: "emptyResult")
                    return
                }
                continuation.finish()
            }
        }
        continuation.onTermination = { _ in
            task.cancel()
        }

        return stream
    }
}

// MARK: - ImageLoaderError

enum ImageLoaderError: Error {
    case emptyResult
}

