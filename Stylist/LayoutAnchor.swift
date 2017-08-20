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

public struct LayoutAnchor {

    public let constant: CGFloat
    public let equality: NSLayoutRelation
    public let ratio: Bool

    public init(constant: CGFloat, equality: NSLayoutRelation = .equal, ratio: Bool = false) {
        self.constant = constant
        self.equality = equality
        self.ratio = ratio
    }

}

extension NSLayoutRelation {

    var symbol: String {
        switch self {
        case .equal: return "=="
        case .greaterThanOrEqual: return ">="
        case .lessThanOrEqual: return "<="
        }
    }

    static var all: [NSLayoutRelation] = [.equal, .greaterThanOrEqual, .lessThanOrEqual]
}

extension LayoutAnchor: StyleValue {

    public static func parse(value: Any) -> LayoutAnchor? {
        if let constant = CGFloat.parse(value: value) {
            return LayoutAnchor(constant: constant)
        } else if let string = value as? String {
            var parsedString = string
            var equality: NSLayoutRelation = .equal
            for possibleEquality in NSLayoutRelation.all {
                if parsedString.hasPrefix(possibleEquality.symbol) {
                    equality = possibleEquality
                    parsedString = parsedString.replacingOccurrences(of: possibleEquality.symbol, with: "").trimmingCharacters(in: .whitespaces)
                }
            }

            var ratio = false
            if parsedString.hasPrefix("*") {
                parsedString = parsedString.replacingOccurrences(of: "*", with: "")
                ratio = true
            }
            if let constant = CGFloat.parse(value: parsedString) {
                return LayoutAnchor(constant: constant, equality: equality, ratio: ratio)
            }
        }
        return nil
    }
}
