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
    public let selector: String
    let components: [SelectorComponent]
    let properties: [StylePropertyValue]
    let parentStyle: Style?

    init(selector: String, properties: [StylePropertyValue], parentStyle: Style? = nil) throws {
        self.selector = selector
        self.properties = properties
        self.parentStyle = parentStyle
        self.components = try SelectorComponent.components(from: selector)
    }

    public static func == (lhs: Style, rhs: Style) -> Bool {
        return lhs.selector == rhs.selector
            && lhs.properties == rhs.properties
            && lhs.parentStyle == rhs.parentStyle
    }

    func applies(to styleable: Styleable) -> Bool {
        let component = components.first!
        if let classType = component.classType,
            let object = styleable as? NSObject,
            !(object.isKind(of: classType)) {
            return false
        }
        if let style = component.style, !styleable.styles.contains(style) {
            return false
        }
        return true
    }
}

struct SelectorComponent: Equatable {
    var classType: AnyClass?
    var style: String?

    static func components(from string: String) throws -> [SelectorComponent] {
        return try string.components(separatedBy: " ").map { component in
            let parts = component.split(separator: ".").map(String.init)

            var classType: AnyClass?
            var style: String?

            switch parts.count {
            case 1:
                if parts[0].hasLowercasePrefix {
                    style = parts[0]
                } else {
                    classType = NSClassFromString(parts[0])
                }
            case 2:
                if parts[1].hasLowercasePrefix {
                    classType = NSClassFromString(parts[0])
                    style = parts[1]
                } else {
                    let className = "\(parts[0]).\(parts[1])".replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "-", with: "_")
                    classType = NSClassFromString(className)
                }
            case 3:
                style = parts[2]
                let className = "\(parts[0]).\(parts[1])".replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "-", with: "_")
                classType = NSClassFromString(className)
            default:
                throw ThemeError.invalidStyleSelector(string)
            }
            if classType == nil && style == nil {
                throw ThemeError.invalidStyleSelector(string)
            }
            return SelectorComponent(classType: classType, style: style)
        }
    }

    static func == (lhs: SelectorComponent, rhs: SelectorComponent) -> Bool {
        return lhs.classType == rhs.classType &&
            lhs.style == rhs.style
    }
}

fileprivate extension String {

    var hasLowercasePrefix: Bool {
        let firstChar = String(prefix(upTo: index(after: startIndex)))
        return firstChar.uppercased() != firstChar
    }
}

enum ClassType {
    case sdkClass
    case customClass
}
