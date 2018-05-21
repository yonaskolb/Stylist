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

    public init(device: UIUserInterfaceIdiom = .unspecified) {
        self.device = device
    }

    var isValidDevice: Bool {
        return device == .unspecified || device == UIDevice.current.userInterfaceIdiom
    }
}

extension StyleContext {

    static func getContext(id: String) throws -> (name: String, context: StyleContext) {

        var device = UIUserInterfaceIdiom.unspecified
        var name = id
        if let match = try! NSRegularExpression(pattern: "(.*)\\((.*)\\)", options: []).firstMatch(in: name, options: [], range: NSRange(location: 0, length: name.count)) {

            name = (id as NSString).substring(with: match.range(at: 1))
            let contextString = (id as NSString).substring(with: match.range(at: 2))
            let contextArray = contextString
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
            let context = try Dictionary(uniqueKeysWithValues: contextArray
                .map { string -> (String, String) in
                    let parts = string
                        .split(separator: ":")
                        .map(String.init)
                        .map { $0.trimmingCharacters(in: .whitespaces) }
                    if parts.count != 2 {
                        throw ThemeError.invalidStyleContext(id)
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
                default:
                    throw ThemeError.invalidStyleContext(id)
                }
            }
        }

        return (name, StyleContext(device: device))
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
