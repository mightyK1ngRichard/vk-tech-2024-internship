//
//  SDYouTubeSnippetModel.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import Foundation
import UIKit
import SwiftData

@Model
final class SDYouTubeSnippetModel: Identifiable, SDModelable {
    @Attribute(.unique)
    var _id: String
    var _title: String?
    var _descriptionInfo: String?
    @Attribute(.externalStorage)
    var _previewImageData: Data?
    var _publishedAt: String
    var _channelTitle: String

    init(
        id: String,
        title: String? = nil,
        description: String? = nil,
        previewImageData: Data?,
        publishedAt: String,
        channelTitle: String
    ) {
        self._id = id
        self._title = title
        self._descriptionInfo = description
        self._previewImageData = previewImageData
        self._publishedAt = publishedAt
        self._channelTitle = channelTitle
    }
}

// MARK: - YouTubeSnippetModel

extension YouTubeSnippetModel {

    init(sdModel: SDYouTubeSnippetModel) {
        id = sdModel._id
        title = sdModel._title
        description = sdModel._descriptionInfo
        publishedAt = sdModel._publishedAt
        channelTitle = sdModel._channelTitle
        if let data = sdModel._previewImageData {
            previewImageState = .data(data)
        } else {
            previewImageState = .none
        }
    }
}

// MARK: - CRUD

extension SDYouTubeSnippetModel {
    
    /// Проверяем, сохранён ли сниппет на устройстве по id
    /// - Returns: Флаг существования
    func isSaved(context: ModelContext) -> Bool {
        let snippetID = _id
        let predicate = #Predicate<SDYouTubeSnippetModel> { $0._id == snippetID }
        let descriptor = FetchDescriptor(predicate: predicate)
        let results = (try? context.fetch(descriptor)) ?? []
        return !results.isEmpty
    }
}
