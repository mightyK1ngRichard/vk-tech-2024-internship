//
//  Logger.swift
//  VKNews
//
//  Created by Dmitriy Permyakov on 03.12.2024.
//

import Foundation

final class Logger {
    private init() {}

    static func log(
        kind: Kind = .info,
        message: Any,
        fileName: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let swiftFileName = fileName.split(separator: "/").last ?? "file not found"
        print("[ \(kind.rawValue.uppercased()) ]: [ \(Date()) ]: [ \(swiftFileName) ] [ \(function) ]: [ #\(line) ]")
        print(message)
        print()
        #endif
    }

    enum Kind: String, Hashable {
        case info = "ℹ️ info"
        case error = "⛔️ error"
        case warning = "⚠️ warning"
    }
}
