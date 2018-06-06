//
//  Color.swift
//  Stylist
//
//  Created by Yonas Kolb on 19/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias Color = UIColor
#elseif os(macOS)
    import Cocoa
    public typealias Color = NSColor
#endif

extension Color: StyleValue {

    public typealias ParsedType = Color

    public static func parse(value: Any) -> Color? {
        let string = String(describing: value)
        var colorString = string
        var color: Color?
        let parts = string.components(separatedBy: ":")
        var alpha: CGFloat?
        if parts.count == 2 {
            colorString = parts[0]
            alpha = CGFloat.parse(value: parts[1])
        }

        // named color
        if #available(iOS 11.0, tvOSApplicationExtension 11.0, *),
            let color = Color(named: colorString) {
                return color
        }
        switch colorString.lowercased().replacingOccurrences(of: " ", with: "") {
        case "red": color = .red
        case "blue": color = .blue
        case "green": color = .green
        case "purple": color = .purple
        case "yellow": color = .yellow
        case "orange": color = .orange
        case "gray", "grey": color = .gray
        case "brown": color = .brown
        case "cyan": color = .cyan
        case "magenta": color = .magenta
        case "darkgray", "darkgrey": color = .darkGray
        case "lightgray", "lightgrey": color = .lightGray
        case "white": color = .white
        case "black": color = .black
        case "none", "transparent", "clear": color = .clear
        default: color = Color(hexString: colorString)
        }
        if let alpha = alpha, alpha < 1 {
            color = color?.withAlphaComponent(alpha)
        }
        return color
    }
}

/// An extension of UIColor (on iOS) or NSColor (on OSX) providing HEX color handling.
extension Color {

    /**
     Create non-autoreleased color with in the given hex string. Alpha will be set as 1 by default.
     - parameter hexString: The hex string, with or without the hash character. Can include the alpha has an extra 2 characters
     - returns: A color with the given hex string.
     */
    public convenience init?(hexString: String) {
        var hex = hexString

        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }
        var alpha: Float = 1.0
        if hex.count == 8 {
            let alphaHex = hex[hex.index(hex.startIndex, offsetBy: 6) ..< hex.index(hex.startIndex, offsetBy: 8)]
            var alphaInt: CUnsignedInt = 0

            Scanner(string: String(alphaHex)).scanHexInt32(&alphaInt)
            alpha = Float(alphaInt) / 255.0
            hex = String(hex[..<hex.index(hex.startIndex, offsetBy: 6)])
        }

        self.init(hexString: hex, alpha: alpha)
    }

    /**
     Create non-autoreleased color with in the given hex string and alpha.
     - parameter hexString: The hex string, with or without the hash character.
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: A color with the given hex string and alpha.
     */
    public convenience init?(hexString: String, alpha: Float) {
        var hex = hexString

        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }

        if hex.range(of: "(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .regularExpression) != nil {

            // Deal with 3 character Hex strings
            if hex.count == 3 {
                let redHex = String(hex[..<hex.index(hex.startIndex, offsetBy: 1)])
                let greenHex = String(hex[hex.index(hex.startIndex, offsetBy: 1) ..< hex.index(hex.startIndex, offsetBy: 2)])
                let blueHex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])

                hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
            }

            let redHex = String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])
            let greenHex = String(hex[hex.index(hex.startIndex, offsetBy: 2) ..< hex.index(hex.startIndex, offsetBy: 4)])
            let blueHex = String(hex[hex.index(hex.startIndex, offsetBy: 4) ..< hex.index(hex.startIndex, offsetBy: 6)])

            var redInt: CUnsignedInt = 0
            var greenInt: CUnsignedInt = 0
            var blueInt: CUnsignedInt = 0

            Scanner(string: redHex).scanHexInt32(&redInt)
            Scanner(string: greenHex).scanHexInt32(&greenInt)
            Scanner(string: blueHex).scanHexInt32(&blueInt)

            self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alpha))
        } else {
            // Note:
            // The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
            // so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
            // in future releases, not a feature. -- Apple Forum
            self.init()
            return nil
        }
    }

    /**
     Create non-autoreleased color with in the given hex value. Alpha will be set as 1 by default.
     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
     - returns: A color with the given hex value
     */
    public convenience init?(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }

    /**
     Create non-autoreleased color with in the given hex value and alpha
     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: color with the given hex value and alpha
     */
    public convenience init?(hex: Int, alpha: Float) {
        var hexString = String(format: "%2X", hex)
        let leadingZerosString = String(repeating: "0", count: 6 - hexString.count)
        hexString = leadingZerosString + hexString
        self.init(hexString: hexString as String, alpha: alpha)
    }
}
