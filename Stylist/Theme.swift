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

    public var styles: [String: [StyleAttribute]]

    public init(styles: [String: [StyleAttribute]]) {
        self.styles = styles
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
        var styles: [String: [StyleAttribute]] = [:]
        for (key, value) in dictionary {
            if let styleDictionary = value as? [String: Any] {
                var attributes: [StyleAttribute] = []
                for (attributeName, value) in styleDictionary {
                    if let attribute = try StyleAttribute(name: attributeName, value: value) {
                        attributes.append(attribute)
                    }
                }
                if !attributes.isEmpty {
                    styles[key] = attributes
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
