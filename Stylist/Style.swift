//
//  Style.swift
//  Stylist
//
//  Created by Yonas Kolb on 19/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif

public class Style: Equatable {
    public let name: String
    let properties: [StylePropertyValue]
    let parentStyle: Style?

    init(name: String, properties: [StylePropertyValue], parentStyle: Style? = nil) {
        self.name = name
        self.properties = properties
        self.parentStyle = parentStyle
    }

    public static func == (lhs: Style, rhs: Style) -> Bool {
        return lhs.name == rhs.name
            && lhs.properties == rhs.properties
            && lhs.parentStyle == rhs.parentStyle
    }
}
