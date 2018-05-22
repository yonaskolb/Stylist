//
//  UIKit.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/5/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

extension CGFloat: StyleValue {

    public static func parse(value: Any) -> CGFloat? {
        if let float = value as? CGFloat {
            return float
        } else if let double = value as? Double {
            return CGFloat(double)
        } else if let string = value as? String {
            if let double = Double(string) {
                return CGFloat(double)
            }
        }
        return Float.parse(value: value).flatMap { CGFloat($0) }
    }
}

extension CGPoint: StyleValue {

    public static func parse(value: Any) -> CGPoint? {
        var floats: [CGFloat]?
        if let float = CGFloat.parse(value: value) {
            return CGPoint(x: float, y: float)
        } else if let string = value as? String {
            let edgeStrings = string.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            floats = edgeStrings.compactMap { CGFloat.parse(value: $0) }
        } else if let array = value as? [Any] {
            floats = array.compactMap { CGFloat.parse(value: $0) }
        }
        if let floats = floats {
            if floats.count == 2 {
                return CGPoint(x: floats[0], y: floats[1])
            }
        }
        return nil
    }
}

extension CGRect: StyleValue {

    public static func parse(value: Any) -> CGRect? {
        var floats: [CGFloat]?
        if let string = value as? String {
            let edgeStrings = string.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            floats = edgeStrings.compactMap { CGFloat.parse(value: $0) }
        } else if let array = value as? [Any] {
            floats = array.compactMap { CGFloat.parse(value: $0) }
        }
        if let floats = floats {
            if floats.count == 4 {
                return CGRect(x: floats[0], y: floats[1], width: floats[2], height: floats[3])
            }
        }

        return nil
    }
}

extension UIEdgeInsets: StyleValue {

    public static func parse(value: Any) -> UIEdgeInsets? {
        var edges: [CGFloat]?
        if let float = CGFloat.parse(value: value) {
            return UIEdgeInsets(top: float, left: float, bottom: float, right: float)
        } else if let string = value as? String {
            let edgeStrings = string.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            edges = edgeStrings.compactMap { CGFloat.parse(value: $0) }
        } else if let array = value as? [Any] {
            edges = array.compactMap { CGFloat.parse(value: $0) }
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
        } else if let string = value as? String {
            let edgeStrings = string.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            edges = edgeStrings.compactMap { CGFloat.parse(value: $0) }
        } else if let array = value as? [Any] {
            edges = array.compactMap { CGFloat.parse(value: $0) }
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
        switch string.lowercased().replacingOccurrences(of: " ", with: "") {
        case "fill": return .fill
        case "leading": return .leading
        case "top": return .top
        case "firstbaseline": return .firstBaseline
        case "center": return .center
        case "trailing": return .trailing
        case "bottom": return .bottom
        case "lastbaseline": return .lastBaseline
        default: return nil
        }
    }
}

extension UIStackViewDistribution: StyleValue {

    public static func parse(value: Any) -> UIStackViewDistribution? {
        guard let string = value as? String else { return nil }
        switch string.lowercased().replacingOccurrences(of: " ", with: "") {
        case "fill": return .fill
        case "fillequally": return .fillEqually
        case "fillproportionally": return .fillProportionally
        case "equalspacing": return .equalSpacing
        case "equalcentering": return .equalCentering
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
        switch string.lowercased().replacingOccurrences(of: " ", with: "") {
        case "black": return .black
        case "blacktranslucent": return .blackTranslucent
        case "default": return .default
        default: return nil
        }
    }
}
#endif
