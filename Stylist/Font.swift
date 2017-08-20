//
//  Font.swift
//  Stylist
//
//  Created by Yonas Kolb on 19/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
    public typealias Font = UIFont
#else
    import Cocoa
    public typealias Font = NSFont
#endif

extension Font: StyleValue {

    public static func parse(value: Any) -> Font? {
        if let int = value as? Int {
            return UIFont.systemFont(ofSize: CGFloat(int))
        }
        if let double = value as? Double {
            return UIFont.systemFont(ofSize: CGFloat(double))
        } else if let string = value as? String {
            let parts = string.components(separatedBy: ":")
            if parts.count == 1 {
                if let textStyle = UIFontTextStyle(name: string) {
                    return UIFont.preferredFont(forTextStyle: textStyle)
                }
            } else if parts.count == 2 {
                let name = parts[0]
                if let size = Double(parts[1]) {
                    let fontSize = CGFloat(size)
                    if let font = UIFont(name: name, size: fontSize) {
                        return font
                    }
                    if name.contains("system") {
                        let systemName = name.replacingOccurrences(of: "system", with: "").lowercased()
                        let weight: CGFloat?
                        switch systemName {
                        case "black":
                            weight = UIFontWeightBlack
                        case "heavy":
                            weight = UIFontWeightHeavy
                        case "light":
                            weight = UIFontWeightLight
                        case "medium":
                            weight = UIFontWeightMedium
                        case "semibold":
                            weight = UIFontWeightSemibold
                        case "thin":
                            weight = UIFontWeightThin
                        case "ultralight":
                            weight = UIFontWeightUltraLight
                        case "bold":
                            return UIFont.boldSystemFont(ofSize: fontSize)
                        case "italic":
                            return UIFont.italicSystemFont(ofSize: fontSize)
                        default: weight = nil
                        }
                        if let weight = weight {
                            return UIFont.systemFont(ofSize: fontSize, weight: weight)
                        }
                    }
                } else if let textStyle = UIFontTextStyle(name: parts[1]) {
                    let fontSize = UIFont.preferredFont(forTextStyle: textStyle).pointSize
                    if let font = UIFont(name: name, size: fontSize) {
                        return font
                    }
                }
            }
        }
        return nil
    }
}

private extension UIFontTextStyle {

    init?(name: String) {
        switch name.replacingOccurrences(of: " ", with: "").lowercased() {
        case "title1":
            self = .title1
        case "title2":
            self = .title2
        case "title3":
            self = .title3
        case "headline":
            self = .headline
        case "subheadline":
            self = .subheadline
        case "body":
            self = .body
        case "callout":
            self = .callout
        case "footnote":
            self = .footnote
        case "caption1":
            self = .caption1
        case "caption2":
            self = .caption2
        default: return nil
        }
    }
}
