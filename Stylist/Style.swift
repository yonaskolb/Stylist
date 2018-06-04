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

    public static func == (lhs: Style, rhs: Style) -> Bool {
        return lhs.properties == rhs.properties
            && lhs.subStyles == rhs.subStyles
    }
}
