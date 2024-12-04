//
//  ImageLoaderService.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import UIKit

// MARK: - ImageLoaderError

enum ImageLoaderError: Error {
    case incorrectImageData
    case emptyResult
}

// MARK: - ImageLoaderProtocol

protocol ImageLoaderServiceProtocol: Sendable {
    func loadImage(from url: URL) async throws -> UIImage
    func loadImages(from urls: [URL]) async throws -> AsyncThrowingStream<UIImage, Error>
    func loadImages(from urls: [(id: String, url: URL)]) async throws -> AsyncThrowingStream<(id: String, image: UIImage), Error>
}

// MARK: - ImageLoaderService

final class ImageLoaderService: ImageLoaderServiceProtocol {
    typealias ImageWithID = (id: String, image: UIImage)

    func loadImage(from url: URL) async throws -> UIImage {
        let request = URLRequest(url: url, timeoutInterval: 1)
        let (data, _) = try await URLSession.shared.data(for: request)
        guard let image = UIImage(data: data) else {
            throw ImageLoaderError.incorrectImageData
        }

        return image
    }

    func loadImages(from urls: [(id: String, url: URL)]) async throws -> AsyncThrowingStream<ImageWithID, Error> {
        let (stream, continuation) = AsyncThrowingStream<ImageWithID, Error>.makeStream()
        let task = Task {
            await withTaskGroup(of: ImageWithID?.self) { group in
                for (id, url) in urls {
                    group.addTask {
                        guard let image = try? await self.loadImage(from: url) else { return nil }
                        return (id: id, image: image)
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

    func loadImages(from urls: [URL]) async throws -> AsyncThrowingStream<UIImage, Error> {
        let (stream, continuation) = AsyncThrowingStream<UIImage, Error>.makeStream()
        let task = Task {
            await withTaskGroup(of: UIImage?.self) { group in
                for url in urls {
                    _ = group.addTaskUnlessCancelled {
                        try? await self.loadImage(from: url)
                    }
                }
                var hasImages = false
                for await image in group {
                    guard let image else { continue }
                    continuation.yield(image)
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
