//
//  StyleValue.swift
//  Stylist
//
//  Created by Yonas Kolb on 20/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif

public protocol StyleValue {
    associatedtype ParsedType
    static func parse(value: Any) -> ParsedType?
}

extension String: StyleValue {
    public static func parse(value: Any) -> String? {
        return value as? String
    }
}

extension Int: StyleValue {

    public static func parse(value: Any) -> Int? {
        if let string = value as? String {
            return Int(string)
        }
        return value as? Int
    }
}

extension Double: StyleValue {

    public static func parse(value: Any) -> Double? {
        if let int = value as? Int {
            return Double(int)
        } else if let string = value as? String {
            return Double(string)
        }
        return value as? Double
    }
}

extension Float: StyleValue {

    public static func parse(value: Any) -> Float? {
        if let int = value as? Int {
            return Float(int)
        } else if let string = value as? String {
            return Float(string)
        } else if let double = value as? Double {
            return Float(double)
        }
        return value as? Float
    }
}

extension CGFloat: StyleValue {

    public static func parse(value: Any) -> CGFloat? {
        return Float.parse(value: value).flatMap { CGFloat($0) }
    }
}

extension Bool: StyleValue {

    public static func parse(value: Any) -> Bool? {
        if let string = value as? String {
            switch string.lowercased() {
            case "yes","true": return true
            case "no","false": return false
            default: break
            }
        }
        return value as? Bool
    }
}

extension UIEdgeInsets: StyleValue {

    public static func parse(value: Any) -> UIEdgeInsets? {
        var edges: [CGFloat]?
        if let float = CGFloat.parse(value: value) {
            return UIEdgeInsets(top: float, left: float, bottom: float, right: float)
        }
        else if let string = value as? String {
            let edgeStrings = string.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            edges = edgeStrings.compactMap{CGFloat.parse(value: $0)}
        } else if let array = value as? [Any] {
            edges = array.compactMap{CGFloat.parse(value: $0)}
        }
        if let edges = edges {
            if edges.count == 2 {
                return UIEdgeInsets(top: edges[1], left: edges[0], bottom: edges[1], right: edges[0])
            } else if edges.count == 4 {
                return UIEdgeInsets(top: edges[0], left: edges[1], bottom: edges[2], right: edges[3])
            }
        }

        return nil
    }
}

extension UIViewContentMode: StyleValue {

    public static func parse(value: Any) -> UIViewContentMode? {
        guard let string = value as? String else {
            return nil
        }
        switch string.replacingOccurrences(of: " ", with: "").lowercased() {
        case "bottom": return .bottom
        case "bottomleft": return .bottomLeft
        case "bottomright": return .bottomRight
        case "center": return .center
        case "left": return .left
        case "redraw": return .redraw
        case "right": return .right
        case "scaleaspectfill": return .scaleAspectFill
        case "scaleaspectfit": return .scaleAspectFit
        case "scaletofill": return .scaleToFill
        case "top": return .top
        case "topleft": return .topLeft
        case "topright": return .topRight
        default: return nil
        }
    }
}

extension CGSize: StyleValue {

    public static func parse(value: Any) -> CGSize? {
        var edges: [CGFloat]?
        if let float = CGFloat.parse(value: value) {
            return CGSize(width: float, height: float)
        }
        else if let string = value as? String {
            let edgeStrings = string.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            edges = edgeStrings.compactMap{CGFloat.parse(value: $0)}
        } else if let array = value as? [Any] {
            edges = array.compactMap{CGFloat.parse(value: $0)}
        }
        if let edges = edges {
            if edges.count == 2 {
                return CGSize(width: edges[0], height: edges[1])
            }
        }

        return nil
    }
}

extension UIStackViewAlignment: StyleValue {

    public static func parse(value: Any) -> UIStackViewAlignment? {
        guard let string = value as? String else { return nil }
        switch string {
        case "fill": return .fill
        case "leading": return .leading
        case "top": return .top
        case "firstBaseline": return .firstBaseline
        case "center": return .center
        case "trailing": return .trailing
        case "bottom": return .bottom
        case "lastBaseline": return .lastBaseline
        default: return nil
        }
    }
}

extension UIStackViewDistribution: StyleValue {

    public static func parse(value: Any) -> UIStackViewDistribution? {
        guard let string = value as? String else { return nil }
        switch string.lowercased().replacingOccurrences(of: " ", with: "") {
        case "fill": return .fill
        case "fillEqually": return .fillEqually
        case "fillProportionally": return .fillProportionally
        case "equalSpacing": return .equalSpacing
        case "equalCentering": return .equalCentering
        default: return nil
        }
    }
}

extension UILayoutConstraintAxis: StyleValue {

    public static func parse(value: Any) -> UILayoutConstraintAxis? {
        guard let string = value as? String else { return nil }
        switch string.lowercased().replacingOccurrences(of: " ", with: "") {
        case "vertical": return .vertical
        case "horizontal": return .horizontal
        default: return nil
        }
    }
}

#if os(iOS)
    extension UIBarStyle: StyleValue {

        public static func parse(value: Any) -> UIBarStyle? {
            guard let string = value as? String else { return nil }
            switch string {
            case "black": return .black
            case "default": return .default
            default: return nil
            }
        }
    }
#endif
