//
//  SnippetDetailInteractor.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import Foundation
import SwiftData

protocol SnippetDetailInteractorProtocol: AnyObject {
    // Memory
    func updateSnippetInMemory(snippetID: String, title: String, description: String)
    func setModelContext(context: ModelContext)
}

// MARK: - SnippetDetailInteractor

final class SnippetDetailInteractor: SnippetDetailInteractorProtocol {
    var presenter: SnippetDetailPresenterProtocol?
    private var modelContext: ModelContext?

    init(
        presenter: SnippetDetailPresenterProtocol? = nil,
        modelContext: ModelContext? = nil
    ) {
        self.presenter = presenter
        self.modelContext = modelContext
    }
}

// MARK: - SnippetDetailInteractorProtocol

extension SnippetDetailInteractor {

    func updateSnippetInMemory(snippetID: String, title: String, description: String) {
        guard let modelContext else {
            Logger.log(kind: .error, message: "model context is nil")
            presenter?.showError("В данный момент сохранение данных невозможно. Попробуйте позже. Проблема уже известна и мы работаем над этим!")
            return
        }

        let predicate = #Predicate<SDYouTubeSnippetModel> { $0._id == snippetID }
        let descriptor = FetchDescriptor(predicate: predicate)
        guard
            let result = try? modelContext.fetch(descriptor),
            let sdSnippet = result.first
        else {
            presenter?.showError("Изменяемый элемент не найден в памяти. Вы не можете его изменить.")
            return
        }
        sdSnippet._title = title
        sdSnippet._descriptionInfo = description

        do {
            try modelContext.save()
            presenter?.savedSuccessful(snippetID: snippetID, title: title, description: description)
        } catch {
            Logger.log(kind: .error, message: error)
            presenter?.showError("Ошибка при сохранении данных! Повторите попытку позже.")
        }
    }

    func setModelContext(context: ModelContext) {
        guard modelContext == nil else { return }
        modelContext = context
    }
}
