//
//  StyleContext.swift
//  Stylist
//
//  Created by Yonas Kolb on 21/5/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation
import UIKit

public struct StyleContext: Equatable {

    public let device: UIUserInterfaceIdiom
    public let horizontalSizeClass: UIUserInterfaceSizeClass
    public let verticalSizeClass: UIUserInterfaceSizeClass

    public init(device: UIUserInterfaceIdiom = .unspecified,
                horizontalSizeClass: UIUserInterfaceSizeClass = .unspecified,
                verticalSizeClass: UIUserInterfaceSizeClass = .unspecified) {
        self.device = device
        self.horizontalSizeClass = horizontalSizeClass
        self.verticalSizeClass = verticalSizeClass
    }

    func targets(styleable: Any) -> Bool {
        if let view = styleable as? UIView {
            if horizontalSizeClass != .unspecified,
                horizontalSizeClass != view.traitCollection.horizontalSizeClass {
                return false
            }

            if verticalSizeClass != .unspecified,
                verticalSizeClass != view.traitCollection.verticalSizeClass {
                return false
            }
        }
        return isValidDevice
    }

    var isValidDevice: Bool {
        return device == .unspecified || device == UIDevice.current.userInterfaceIdiom
    }
}

extension StyleContext {

    static func getContext(string: String) throws -> (name: String, context: StyleContext) {

        var device = UIUserInterfaceIdiom.unspecified
        var horizontalSizeClass = UIUserInterfaceSizeClass.unspecified
        var verticalSizeClass = UIUserInterfaceSizeClass.unspecified

        var name = string
        let regex = try NSRegularExpression(pattern: "(.*)\\((.*)\\)", options: [])
        if let match = regex.firstMatch(in: name, options: [], range: NSRange(location: 0, length: name.count)) {

            name = (string as NSString).substring(with: match.range(at: 1))

            let contextString = (string as NSString).substring(with: match.range(at: 2))
            let contextArray = contextString
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }

            let context = try Dictionary(uniqueKeysWithValues: contextArray
                .map { keyAndValue -> (String, String) in
                    let parts = keyAndValue
                        .split(separator: ":")
                        .map(String.init)
                        .map { $0.trimmingCharacters(in: .whitespaces) }
                    if parts.count != 2 {
                        throw ThemeError.invalidStyleContext(string)
                    }
                    return (parts[0], parts[1])
                }
            )

            for (key, value) in context {
                switch key {
                case "device":
                    if let value = UIUserInterfaceIdiom(name: value) {
                        device = value
                    } else {
                        throw ThemeError.invalidDevice(name: name, device: value)
                    }
                case "h", "horizontal":
                    if let value = UIUserInterfaceSizeClass(name: value) {
                        horizontalSizeClass = value
                    } else {
                        throw ThemeError.invalidSizeClass(name: name, sizeClass: value)
                    }
                case "v", "vertical":
                    if let value = UIUserInterfaceSizeClass(name: value) {
                        verticalSizeClass = value
                    } else {
                        throw ThemeError.invalidSizeClass(name: name, sizeClass: value)
                    }
                default:
                    throw ThemeError.invalidStyleContext(string)
                }
            }
        }

        let context = StyleContext(device: device,
                                   horizontalSizeClass: horizontalSizeClass,
                                   verticalSizeClass: verticalSizeClass)
        return (name, context)
    }
}

extension UIUserInterfaceIdiom {

    init?(name: String) {
        switch name.lowercased() {
        case "iphone", "phone": self = .phone
        case "ipad", "pad": self = .pad
        case "tv": self = .tv
        default: return nil
        }
    }
}

extension UIUserInterfaceSizeClass {

    init?(name: String) {
        switch name.lowercased() {
        case "compact": self = .compact
        case "regular": self = .regular
        default: return nil
        }
    }
}
