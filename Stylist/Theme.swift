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

    public let variables: [String: Any]
    public let styles: [Style]

    public init(variables: [String: Any] = [:], styles: [Style] = []) {
        self.variables = variables
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
        var stylesDictionary = dictionary

        if let variablesDictionary = dictionary["variables"] as? [String: Any] {
            variables = variablesDictionary
            stylesDictionary = (dictionary["styles"] as? [String: Any]) ?? [:]
        }
        self.variables = variables

        for (key, value) in stylesDictionary {
            if var styleDictionary = value as? [String: Any] {
                var attributes: [StyleAttribute] = []
                if let styles = styleDictionary["styles"] as? [String] {
                    for style in styles {
                        if let sharedStyle = stylesDictionary[style] as? [String: Any] {
                            for (styleKey, styleValue) in sharedStyle {
                                if styleDictionary[styleKey] == nil {
                                    styleDictionary[styleKey] = styleValue
                                }
                            }
                        } else {
                            throw ThemeError.invalidStyleReference(style)
                        }
                    }
                }

                for (attributeName, value) in styleDictionary {
                    if attributeName == "styles" {
                        continue
                    }

                    var attributeValue = value
                    if let string = attributeValue as? String, string.hasPrefix("$") {
                        var variableName = string.trimmingCharacters(in: CharacterSet(charactersIn: "$"))
                        let parts = variableName.components(separatedBy: ":")
                        if parts.count > 1 {
                            variableName = parts[0]
                        }
                        guard let variable = variables[variableName] else {
                            throw ThemeError.invalidVariable(name: attributeName, variable: variableName)
                        }
                        attributeValue = variable
                        if parts.count > 1 {
                            attributeValue = "\(attributeValue):" + Array(parts.dropFirst()).joined(separator: ":")
                        }
                    }
                    if let attribute = try StyleAttribute(name: attributeName, value: attributeValue) {
                        attributes.append(attribute)
                    } else {
                        print("Unknown attribute in \(key): \(attributeName)")
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
    case invalidVariable(name:String, variable: String)
    case invalidStyleReference(String)
}
