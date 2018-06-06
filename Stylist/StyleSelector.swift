//
//  StyleSelector.swift
//  Stylist
//
//  Created by Yonas Kolb on 4/6/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

public class StyleSelector: Equatable, CustomStringConvertible {
    public let selector: String
    let components: [SelectorComponent]
    let style: Style

    init(selector: String, style: Style) throws {
        self.selector = selector
        self.components = try SelectorComponent.components(from: selector)
        self.style = style
    }

    public var description: String {
        return selector
    }

    public static func == (lhs: StyleSelector, rhs: StyleSelector) -> Bool {
        return lhs.selector == rhs.selector
            && lhs.style == rhs.style
    }

    func applies(to styleable: Styleable) -> Bool {
        var components = self.components
        if let component = components.popLast() {
            if matches(component: component, to: styleable) {
                if !components.isEmpty {
                    return matches(components: components, to: styleable)
                } else {
                    // a single level
                    return true
                }
            }
        }
        // shouldn't get to this state
        return false
    }

    private func matches(component: SelectorComponent, to styleable: Styleable) -> Bool {
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

    private func matches(components: [SelectorComponent], to styleable: Styleable) -> Bool {
        var components = components
        if let component = components.popLast() {
            if let parent = getParent(styleable: styleable, component: component) {
                return matches(components: components, to: parent)
            } else {
                return false
            }
        } else {
            return true
        }
    }

    private func getParent(styleable: Styleable, component: SelectorComponent) -> Styleable? {

        if let viewController = styleable as? UIViewController {
            if let parent = viewController.parent {
                if matches(component: component, to: parent) {
                    return parent
                } else {
                    return getParent(styleable:parent, component: component)
                }
            }
        } else if let view = styleable as? UIView {
            if let nextResponder = view.next,
                let parentStyleable = nextResponder as? Styleable {
                if matches(component: component, to: parentStyleable) {
                    return parentStyleable
                } else {
                    return getParent(styleable: parentStyleable, component: component)
                }
            }
        } else {
            print("heirachical selector applied to non UIView")
        }
        return nil
    }

    var specificityIndex: Int {
        return components.reduce(0) { index, component in
            index + (component.classType != nil ? 1 : 0) + (component.style != nil ? 1 : 0)
        }
    }
}

extension StyleSelector: Comparable {

    public static func < (lhs: StyleSelector, rhs: StyleSelector) -> Bool {
        if lhs.specificityIndex == rhs.specificityIndex {
            return lhs.selector < rhs.selector
        } else {
            return lhs.specificityIndex < rhs.specificityIndex
        }
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
