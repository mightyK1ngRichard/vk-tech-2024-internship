//
//  ImageLoaderService.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import Foundation

// MARK: - ImageLoaderError

enum ImageLoaderError: Error {
    case emptyResult
}

// MARK: - ImageLoaderProtocol

protocol ImageLoaderServiceProtocol: Sendable {
    func loadImage(from url: URL) async throws -> Data
    func loadImages(from urls: [URL]) async throws -> AsyncThrowingStream<Data, Error>
    func loadImages(from urls: [(id: String, url: URL)]) async throws -> AsyncThrowingStream<(id: String, imageData: Result<Data, Error>), Error>
}

// MARK: - ImageLoaderService

final class ImageLoaderService: ImageLoaderServiceProtocol {
    typealias ImageDataWithID = (id: String, imageData: Result<Data, Error>)

    func loadImage(from url: URL) async throws -> Data {
        let request = URLRequest(url: url, timeoutInterval: 10)
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
                    guard let result else { continue }
                    continuation.yield(result)
                    hasImages = true
                }

                guard hasImages else {
                    continuation.finish(throwing: ImageLoaderError.emptyResult)
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

    func loadImages(from urls: [URL]) async throws -> AsyncThrowingStream<Data, Error> {
        let (stream, continuation) = AsyncThrowingStream<Data, Error>.makeStream()
        let task = Task {
            await withTaskGroup(of: Data?.self) { group in
                for url in urls {
                    _ = group.addTaskUnlessCancelled {
                        try? await self.loadImage(from: url)
                    }
                }
                var hasImages = false
                for await imageData in group {
                    guard let imageData else { continue }
                    continuation.yield(imageData)
                    hasImages = true
                }

                guard hasImages else {
                    continuation.finish(throwing: ImageLoaderError.emptyResult)
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
