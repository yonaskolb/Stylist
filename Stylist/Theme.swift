//
//  Theme.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation
import Yams

public struct Theme: Equatable {

    public let variables: [String: Any]
    public let styles: [Style]

    public init(variables: [String: Any] = [:], styles: [Style] = []) {
        self.variables = variables
        self.styles = styles.sorted { $0.specificityIndex < $1.specificityIndex }
    }

    public static func == (lhs: Theme, rhs: Theme) -> Bool {
        return NSDictionary(dictionary: lhs.variables).isEqual(to: rhs.variables)
            && lhs.styles == rhs.styles
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
        var variables: [String: Any] = dictionary["variables"] as? [String: Any] ?? [:]
        let stylesDictionary = (dictionary["styles"] as? [String: Any]) ?? [:]

        for (key, value) in stylesDictionary {
            if var styleDictionary = value as? [String: Any] {
                if let styles = styleDictionary["styles"] as? [String] {
                    for style in styles {
                        if let sharedStyle = stylesDictionary[style] as? [String: Any] {
                            for (styleKey, styleValue) in sharedStyle {
                                if styleDictionary[styleKey] == nil {
                                    styleDictionary[styleKey] = styleValue
                                }
                            }
                        } else {
                            throw ThemeError.invalidStyleReference(style: key, reference: style)
                        }
                    }
                }

                func parseStyle(dictionary: [String: Any]) throws -> Style {

                    var properties: [StylePropertyValue] = []

                    for (propertyName, value) in dictionary {
                        if propertyName == "styles" || propertyName == "parent" {
                            continue
                        }

                        func resolveVariable(_ value: Any) throws -> Any {
                            var propertyValue = value
                            if let string = propertyValue as? String, string.hasPrefix("$") {
                                var variableName = string.trimmingCharacters(in: CharacterSet(charactersIn: "$"))
                                let parts = variableName.components(separatedBy: ":")
                                if parts.count > 1 {
                                    variableName = parts[0]
                                }
                                guard let variable = variables[variableName] else {
                                    throw ThemeError.invalidVariable(name: propertyName, variable: variableName)
                                }
                                propertyValue = variable
                                if parts.count > 1 {
                                    propertyValue = "\(propertyValue):" + Array(parts.dropFirst()).joined(separator: ":")
                                }
                            }
                            return propertyValue
                        }

                        let propertyValue = try resolveVariable(value)
                        properties.append(try StylePropertyValue(string: propertyName, value: propertyValue))
                    }
                    var parentStyle: Style?
                    if let parentDictionary = dictionary["parent"] as? [String: Any] {
                        parentStyle = try parseStyle(dictionary: parentDictionary)
                    }
                    return try Style(selector: key, properties: properties, parentStyle: parentStyle)
                }
                let style = try parseStyle(dictionary: styleDictionary)
                styles.append(style)
            }
        }
        self.styles = styles.sorted { $0.specificityIndex < $1.specificityIndex }
        self.variables = variables
    }
}
