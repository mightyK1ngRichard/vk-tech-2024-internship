//
//  String+Extensions.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

extension String {

    var formatDate: String {
        let isoDateFormatter = ISO8601DateFormatter()
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US")
        outputFormatter.dateFormat = "MMMM d, yyyy 'at' h:mm a"

        if let date = isoDateFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        } else {
            return self
        }
    }
}

extension String? {

    var isEmptyOrNil: Bool {
        guard let self else { return true }
        return self.isEmpty
    }
}
