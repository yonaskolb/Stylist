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

extension Font: Parseable {

    static func parse(value: Any) -> Font? {
        if let double = value as? Double {
            return UIFont.systemFont(ofSize: CGFloat(double))
        } else if let string = value as? String {
            let parts = string.components(separatedBy: ":")
            if parts.count == 1 {
                let textStyleString = string.replacingOccurrences(of: " ", with: "").lowercased()
                var textStyle: UIFontTextStyle?
                switch textStyleString {
                case "title1":
                    textStyle = .title1
                case "title2":
                    textStyle = .title2
                case "title3":
                    textStyle = .title3
                case "headline":
                    textStyle = .headline
                case "subheadline":
                    textStyle = .subheadline
                case "body":
                    textStyle = .body
                case "callout":
                    textStyle = .callout
                case "footnote":
                    textStyle = .footnote
                case "caption1":
                    textStyle = .caption1
                case "caption2":
                    textStyle = .caption2
                default: break
                }
                if let textStyle = textStyle {
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
                }
            }
        }
        return nil
    }
}
