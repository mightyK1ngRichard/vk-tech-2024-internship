//
//  VKButton+Defaults.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 04.12.2024.
//

import Foundation

extension VKButton.Configuration {

    /// Готовая конфигурация  с дефолтной настройкой компонента
    /// - Parameters:
    ///   - title: Заголовок кнопки
    ///   - kind: Вид кнопки
    /// - Returns: Конфгируация компонента
    static func basic(
        title: String,
        kind: Kind,
        style: ButtonStyle
    ) -> Self {
        VKButton.Configuration(
            title: title,
            backgroundColor: style.backgroundColor,
            borderColor: style.borderColor,
            selectedBackgroundColor: style.selectedBackgroundColor,
            foregroundColor: style.foregroundColor,
            buttonHeight: kind.buttonHeight,
            cornerRadius: 8,
            borderWidth: style.borderWidth
        )
    }
}
