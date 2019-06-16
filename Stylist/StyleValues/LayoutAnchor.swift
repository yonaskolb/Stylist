//
//  LayoutAnchor.swift
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

public struct LayoutAnchor: Equatable {

    public let constant: CGFloat
    public let equality: NSLayoutConstraint.Relation

    public init(constant: CGFloat, equality: NSLayoutConstraint.Relation = .equal) {
        self.constant = constant
        self.equality = equality
    }
}

extension NSLayoutConstraint.Relation {

    var symbol: String {
        switch self {
        case .equal: return "=="
        case .greaterThanOrEqual: return ">="
        case .lessThanOrEqual: return "<="
        @unknown default: return ""
        }
    }

    static var all: [NSLayoutConstraint.Relation] = [.equal, .greaterThanOrEqual, .lessThanOrEqual]
}

extension LayoutAnchor: StyleValue {

    public static func parse(value: Any) -> LayoutAnchor? {
        if let constant = CGFloat.parse(value: value) {
            return LayoutAnchor(constant: constant)
        } else if let string = value as? String {
            var parsedString = string
            var equality: NSLayoutConstraint.Relation = .equal
            for possibleEquality in NSLayoutConstraint.Relation.all {
                if parsedString.hasPrefix(possibleEquality.symbol) {
                    equality = possibleEquality
                    parsedString = parsedString.replacingOccurrences(of: possibleEquality.symbol, with: "").trimmingCharacters(in: .whitespaces)
                }
            }

            if let constant = CGFloat.parse(value: parsedString) {
                return LayoutAnchor(constant: constant, equality: equality)
            }
        }
        return nil
    }
}

struct AspectRatioAnchor: StyleValue, Equatable {

    let ratio: CGFloat

    public static func parse(value: Any) -> AspectRatioAnchor? {
        if let float = CGFloat.parse(value: value) {
            return AspectRatioAnchor(ratio: float)
        } else if let string = value as? String {
            guard let match = try! NSRegularExpression(pattern: "(\\d*(?:\\.\\d*)?)([:/])(\\d*(?:\\.\\d*)?)", options: []).firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count)) else { return nil }

            let string1 = (string as NSString).substring(with: match.range(at: 1))
            let symbol = (string as NSString).substring(with: match.range(at: 2))
            let string2 = (string as NSString).substring(with: match.range(at: 3))

            guard let number1 = CGFloat.parse(value: string1), let number2 = CGFloat.parse(value: string2) else {
                return nil
            }
            let ratio = symbol == "/" ? (number1 / number2) : number2 / number1
            return AspectRatioAnchor(ratio: CGFloat(ratio))
        }
        return nil
    }
}
