//
//  Theme.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation
import Yams

public struct Theme {

    public var styles: [Style]

    public init(styles: [Style]) {
        self.styles = styles
    }

    func getStyle(_ name: String) -> Style? {
        guard let style = styles.first(where: { $0.name == name}) else {
            return nil
        }
        return style
    }
}

extension Theme {

    public init(path: String) throws {
        guard let data = FileManager.default.contents(atPath: path) else {
            throw ThemeError.notFound
        }
        guard let string = String(data: data, encoding: .utf8) else {
            throw ThemeError.decodingError
        }
        let yaml = try Yams.load(yaml: string)
        guard let dictionary = yaml as? [String: Any] else {
            throw ThemeError.decodingError
        }
        try self.init(dictionary: dictionary)
    }

    public init(dictionary: [String: Any]) throws {
        var styles: [Style] = []
        for (key, value) in dictionary {
            if let styleDictionary = value as? [String: Any] {
                var attributes: [StyleAttribute] = []
                for (attributeName, value) in styleDictionary {
                    if let attribute = try StyleAttribute(name: attributeName, value: value) {
                        attributes.append(attribute)
                    }
                }
                if !attributes.isEmpty {
                    let style = Style(name: key, attributes: attributes)
                    styles.append(style)
                }
            }
        }
        self.styles = styles
    }

}

enum ThemeError: Error {
    case notFound
    case decodingError
}
