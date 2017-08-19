//
//  StyleAttribute.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation
import UIKit

public struct StyleAttribute {

    public let controlState: UIControlState
    public let attribute: Attribute

    public enum Attribute {
    case backgroundColor(Color)
    case borderColor(Color)
    case textColor(Color)
    case font(Font)
    case cornerRadius(Int)
    case borderWidth(Int)
    case alpha(Double)
    case shadowAlpha(Double)
    case backgroundImage(UIImage)
    }
}

extension StyleAttribute {

    init?(name: String, value: Any) throws {

        func parse<T: Parseable>(_ value: Any) throws -> T {
            guard let parsedValue = T.parse(value: value) else {
                throw StyleAttributeError.parsingError(T.self, value)
            }
            return parsedValue as! T
        }

        func cast<T>(_ value: Any) throws -> T {
            guard let parsedValue = value as? T else {
                throw StyleAttributeError.parsingError(T.self, value)
            }
            return parsedValue
        }

        let nameParts = name.components(separatedBy: ":")
        let attributeName = nameParts[0]
        let controlState: UIControlState
        if nameParts.count == 2 {
            let controlStateString = nameParts[1]
            switch controlStateString {
                case "normal": controlState = .normal
                case "application": controlState = .application
                case "disabled": controlState = .disabled
                case "focused": controlState = .focused
                case "highlighted": controlState = .highlighted
                case "reserved": controlState = .reserved
                case "selected": controlState = .selected
                default: throw StyleAttributeError.incorrectControlState(controlStateString)
            }
        } else {
            controlState = .normal
        }

        let attribute: StyleAttribute.Attribute
        switch attributeName {
        case "backgroundColor":
            attribute = try .backgroundColor(parse(value))
        case "borderColor":
            attribute = try .borderColor(parse(value))
        case "textColor":
            attribute = try .textColor(parse(value))
        case "font":
            attribute = try .font(parse(value))
        case "cornerRadius":
            attribute = try .cornerRadius(cast(value))
        case "borderWidth":
            attribute = try .borderWidth(cast(value))
        case "alpha", "opacity":
            attribute = try .alpha(cast(value))
        case "shadowAlpha", "shadowOpacity":
            attribute = try .shadowAlpha(cast(value))
        case "backgroundImage":
            attribute = try .backgroundImage(parse(value))
        default:
            return nil
        }
        self.init(controlState: controlState, attribute: attribute)
    }
}

protocol Parseable {
    associatedtype ParsedType
    static func parse(value: Any) -> ParsedType?
}

enum StyleAttributeError: Error {
    case parsingError(Any.Type, Any)
    case incorrectControlState(String)
}
