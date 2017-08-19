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

    public let attribute: Attribute
    public let controlState: UIControlState
    public let barMetrics: UIBarMetrics

    public enum Attribute {
        case backgroundColor(Color)
        case borderColor(Color)
        case textColor(Color)
        case tintColor(Color)
        case font(Font)
        case cornerRadius(Double)
        case borderWidth(Double)
        case alpha(Double)
        case shadowAlpha(Double)
        case backgroundImage(UIImage)
        case image(UIImage)
        case imageEdgeInsets(UIEdgeInsets)
        case contentEdgeInsets(UIEdgeInsets)
        case titleEdgeInsets(UIEdgeInsets)
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

        let nameParts = name.components(separatedBy: ":")
        let attributeName = nameParts[0]
        let controlState: UIControlState
        let barMetrics: UIBarMetrics = .default
        //TODO: parse UIBarMetrics

        if nameParts.count == 2 {
            let controlStateString = nameParts[1]
            if let parsedControlState = UIControlState(name: controlStateString) {
                controlState = parsedControlState
            } else {
                throw StyleAttributeError.incorrectControlState(controlStateString)
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
        case "tintColor":
            attribute = try .tintColor(parse(value))
        case "textColor":
            attribute = try .textColor(parse(value))
        case "font":
            attribute = try .font(parse(value))
        case "cornerRadius":
            attribute = try .cornerRadius(parse(value))
        case "borderWidth":
            attribute = try .borderWidth(parse(value))
        case "alpha", "opacity":
            attribute = try .alpha(parse(value))
        case "shadowAlpha", "shadowOpacity":
            attribute = try .shadowAlpha(parse(value))
        case "backgroundImage":
            attribute = try .backgroundImage(parse(value))
        case "image":
            attribute = try .image(parse(value))
        case "imageEdgeInsets":
            attribute = try .imageEdgeInsets(parse(value))
        case "contentEdgeInsets":
            attribute = try .contentEdgeInsets(parse(value))
        case "titleEdgeInsets":
            attribute = try .titleEdgeInsets(parse(value))
        default:
            return nil
        }
        self.init(attribute: attribute, controlState: controlState, barMetrics: barMetrics)
    }
}

extension UIControlState {

    init?(name: String) {
        switch name {
        case "normal": self = .normal
        case "application": self = .application
        case "disabled": self = .disabled
        case "focused": self = .focused
        case "highlighted": self = .highlighted
        case "reserved": self = .reserved
        case "selected": self = .selected
        default: return nil
        }
    }
}

protocol Parseable {
    associatedtype ParsedType
    static func parse(value: Any) -> ParsedType?
}

extension Int: Parseable {

    static func parse(value: Any) -> Int? {
        if let string = value as? String {
            return Int(string)
        }
        return value as? Int
    }
}

extension Double: Parseable {

    static func parse(value: Any) -> Double? {
        if let int = value as? Int {
            return Double(int)
        } else if let string = value as? String {
            return Double(string)
        }
        return value as? Double
    }
}

extension UIEdgeInsets: Parseable {

    static func parse(value: Any) -> UIEdgeInsets? {
        var edges: [Double]?
        if let double = Double.parse(value: value) {
            let float = CGFloat(double)
            return UIEdgeInsets(top: float, left: float, bottom: float, right: float)
        }
        else if let string = value as? String {
            let edgeStrings = string.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            edges = edgeStrings.flatMap{Double.parse(value: $0)}
        } else if let array = value as? [Any] {
            edges = array.flatMap{Double.parse(value: $0)}
        }
        if let edges = edges {
            if edges.count == 2 {
                return UIEdgeInsets(top: CGFloat(edges[1]), left: CGFloat(edges[0]), bottom: CGFloat(edges[1]), right: CGFloat(edges[0]))
            } else if edges.count == 4 {
                return UIEdgeInsets(top: CGFloat(edges[0]), left: CGFloat(edges[1]), bottom: CGFloat(edges[2]), right: CGFloat(edges[3]))
            }
        }

        return nil
    }
}

enum StyleAttributeError: Error {
    case parsingError(Any.Type, Any)
    case incorrectControlState(String)
}
