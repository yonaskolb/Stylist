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
        try self.init(data: data)
    }

    public init(data: Data) throws {
        guard let string = String(data: data, encoding: .utf8) else {
            throw ThemeError.decodingError
        }
        try self.init(string: string)
    }

    public init(string: String) throws {
        let yaml = try Yams.load(yaml: string)
        guard let dictionary = yaml as? [String: Any] else {
            throw ThemeError.decodingError
        }
        try self.init(dictionary: dictionary)
    }

    public init(dictionary: [String: Any]) throws {
        var styles: [Style] = []
        var variables: [String: Any] = [:]
        var styleDictionary = dictionary

        if let variablesDictionary = dictionary["variables"] as? [String: Any] {
            variables = variablesDictionary
            styleDictionary = (dictionary["styles"] as? [String: Any]) ?? [:]
        }

        for (key, value) in styleDictionary {
            if let styleDictionary = value as? [String: Any] {
                var attributes: [StyleAttribute] = []
                for (attributeName, value) in styleDictionary {
                    var attributeValue = value
                    if let string = attributeValue as? String, string.hasPrefix("$") {
                        let variableName = string.trimmingCharacters(in: CharacterSet.init(charactersIn: "$"))
                        guard let variable = variables[variableName] else {
                            throw ThemeError.incorrectVariable(name: attributeName, variable: variableName)
                        }
                        attributeValue = variable
                    }
                    if let attribute = try StyleAttribute(name: attributeName, value: attributeValue) {
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
    case incorrectVariable(name:String, variable: String)
}
