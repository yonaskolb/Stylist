//
//  Style.swift
//  Stylist
//
//  Created by Yonas Kolb on 19/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation

public class Style: Equatable {
    let properties: [StylePropertyValue]
    let subStyles: [String: Style]

    init(properties: [StylePropertyValue], subStyles: [String: Style] = [:]) throws {
        self.properties = properties
        self.subStyles = subStyles
    }

    init(dictionary: [String: Any]) throws {
        var properties: [StylePropertyValue] = []
        var subStyles: [String: Style] = [:]

        for (propertyName, value) in dictionary {

            if let subDictionary = value as? [String: Any] {
                let style = try Style(dictionary: subDictionary)
                subStyles[propertyName] = style
                continue
            }

            properties.append(try StylePropertyValue(string: propertyName, value: value))
        }
        self.properties = properties.sorted { $0.name < $1.name }
        self.subStyles = subStyles
    }

    public static func == (lhs: Style, rhs: Style) -> Bool {
        return lhs.properties == rhs.properties
            && lhs.subStyles == rhs.subStyles
    }
}
