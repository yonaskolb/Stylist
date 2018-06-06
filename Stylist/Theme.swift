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
        var stylesDictionary = (dictionary["styles"] as? [String: Any]) ?? [:]

        var visitedStyles: Set<String> = []

        func getResolvedStyle(_ style: String, from parentStyle: String) throws -> [String: Any] {
            guard !visitedStyles.contains(style) else {
                throw ThemeError.styleReferenceCycle(references: visitedStyles)
            }
            visitedStyles.insert(style)

            guard var styleDictionary = stylesDictionary[style] as? [String: Any] else {
                throw ThemeError.invalidStyleReference(style: parentStyle, reference: style)
            }
            if let styles = styleDictionary["styles"] as? [String] {
                for subStyleName in styles {
                    let subStyle = try getResolvedStyle(subStyleName, from: style)
                    for (styleKey, styleValue) in subStyle {
                        if styleDictionary[styleKey] == nil {
                            styleDictionary[styleKey] = styleValue
                        }
                    }
                }
            }
            styleDictionary["styles"] = nil

            for (key, value) in styleDictionary {

                if let string = value as? String, string.hasPrefix("$") {
                    var variableName = string.trimmingCharacters(in: CharacterSet(charactersIn: "$"))
                    let parts = variableName.components(separatedBy: ":")
                    if parts.count > 1 {
                        variableName = parts[0]
                    }
                    guard let variable = variables[variableName] else {
                        throw ThemeError.invalidVariable(name: key, variable: variableName)
                    }
                    var variableValue = variable
                    if parts.count > 1 {
                        variableValue = "\(variableValue):" + Array(parts.dropFirst()).joined(separator: ":")
                    }

                    styleDictionary[key] = variableValue
                }
            }
            return styleDictionary
        }

        self.variables = variables
        self.styles = try stylesDictionary.keys.map { selector in
            visitedStyles = []
            let resolvedStyleDictionary = try getResolvedStyle(selector, from: "")
            let style = try Style(dictionary: resolvedStyleDictionary)
            return try StyleSelector(selector: selector, style: style)
        }.sorted()
    }
}
