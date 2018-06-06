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
    public let styles: [StyleSelector]

    public init(variables: [String: Any] = [:], styles: [StyleSelector] = []) {
        self.variables = variables
        self.styles = styles.sorted()
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
        var styles: [StyleSelector] = []
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
                    styleDictionary["styles"] = nil
                }

                func parseStyle(dictionary: [String: Any]) throws -> Style {

                    var properties: [StylePropertyValue] = []
                    var subStyles: [String: Style] = [:]

                    for (propertyName, value) in dictionary {

                        if let subDictionary = value as? [String: Any] {
                            let style = try parseStyle(dictionary: subDictionary)
                            subStyles[propertyName] = style
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
                   
                    return try Style(properties: properties, subStyles: subStyles)
                }
                let style = try parseStyle(dictionary: styleDictionary)
                let styleSelector = try StyleSelector(selector: key, style: style)
                styles.append(styleSelector)
            }
        }
        self.styles = styles.sorted()
        self.variables = variables
    }
}
