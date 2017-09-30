//
//  Style.swift
//  Stylist
//
//  Created by Yonas Kolb on 19/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif

public class Style {
    public let name: String
    let properties: [StylePropertyValue]
    let parentStyle: Style?

    init(name: String, properties: [StylePropertyValue], parentStyle: Style? = nil) {
        self.name = name
        self.properties = properties
        self.parentStyle = parentStyle
    }
}

struct StylePropertyValue {
    let name: String
    let value: Any
    let context: PropertyContext

    init(name: String, value: Any) throws {

        var propertyName = name

        var device = UIUserInterfaceIdiom.unspecified
        var controlState: UIControlState = .normal
        let barMetrics: UIBarMetrics = .default
        //TODO: parse UIBarMetrics

        if let match = try! NSRegularExpression(pattern: "(.*)\\(device:(.*)\\)", options: []).firstMatch(in: propertyName, options: [], range: NSRange(location: 0, length: propertyName.characters.count)) {

            propertyName = (name as NSString).substring(with: match.range(at: 1))
            let deviceString = (name as NSString).substring(with: match.range(at: 2))
            switch deviceString.lowercased() {
            case "iphone", "phone": device = .phone
            case "ipad", "pad": device = .pad
            case "tv": device = .tv
            default: throw ThemeError.invalidDevice(name: propertyName, device: deviceString)
            }
        }

        let nameParts = propertyName.components(separatedBy: ":")
        propertyName = nameParts[0]



        if nameParts.count == 2 {
            let controlStateString = nameParts[1]
            if let parsedControlState = UIControlState(name: controlStateString) {
                controlState = parsedControlState
            } else {
                throw ThemeError.invalidControlState(name: propertyName, controlState: controlStateString)
            }
        }

        self.name = propertyName
        self.value = value
        self.context = PropertyContext(device: device, controlState: controlState, barMetrics: barMetrics)
    }
}

public struct PropertyContext {

    public let device: UIUserInterfaceIdiom
    public let controlState: UIControlState
    public let barMetrics: UIBarMetrics

    public init(device: UIUserInterfaceIdiom = .unspecified, controlState: UIControlState = .normal, barMetrics: UIBarMetrics = .default) {
        self.device = device
        self.controlState = controlState
        self.barMetrics = barMetrics
    }

    var isValidDevice: Bool {
        return device == .unspecified || device == UIDevice.current.userInterfaceIdiom
    }
}

extension UIControlState {

    init?(name: String) {
        switch name {
        case "normal": self = .normal
        case "application": self = .application
        case "disabled": self = .disabled
        case "focused": self = .focused
        case "highlighted": self = .highlighted
        case "reserved": self = .reserved
        case "selected": self = .selected
        default: return nil
        }
    }
}
