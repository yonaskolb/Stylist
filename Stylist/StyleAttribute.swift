//
//  StyleAttribute.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation
import UIKit

public enum StyleAttribute {
    case backgroundColor(StylistColor)
    case cornerRadius(Int)
    case borderColor(StylistColor)
    case borderWidth(Int)
    case alpha(Double)
    case shadowAlpha(Double)
    case backgroundImage(UIImage)
    case textColor(StylistColor)
    case font(UIFont)
}

extension StyleAttribute {

    init?(name: String, value: Any) throws {

        func parseColor(_ value: Any) throws -> StylistColor {

            if let string = value as? String {
            switch string {
                case "red": return .red
                case "blue": return .blue
                case "green": return .green
                case "purple": return .purple
                case "yellow": return .yellow
                case "orange": return .orange
                case "gray", "grey": return .gray
                case "brown": return .brown
                case "cyan": return .cyan
                case "magenta": return .magenta
                case "darkGray", "darkGrey": return .darkGray
                case "lightGray", "lightGrey": return .lightGray
                case "white": return .white
                case "black": return .black
                case "none", "transparent", "clear": return .clear
                default:
                    if let color = StylistColor(hexString: string) {
                        return color
                }
            }
            } else if let int = value as? Int, let color = StylistColor(hex: int) {
                return color
            } 
            throw StyleAttributeError.parsingError(UIColor.self, value)
        }

        switch name {
        case "backgroundColor":
            self = try .backgroundColor(parseColor(value))
        case "borderColor":
            self = try .borderColor(parseColor(value))
        case "textColor":
            self = try .textColor(parseColor(value))
        default:
            return nil
        }
    }
}

enum StyleAttributeError: Error {
    case parsingError(Any.Type, Any)

    enum ParsingType {
        case color
        case font
    }
}
