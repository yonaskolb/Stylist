//
//  PropertyContext.swift
//  Stylist
//
//  Created by Yonas Kolb on 21/5/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation
import UIKit

public struct PropertyContext: Equatable {

    public let styleContext: StyleContext
    public let controlState: UIControl.State
    public let barMetrics: UIBarMetrics

    public init(styleContext: StyleContext = StyleContext(), controlState: UIControl.State = .normal, barMetrics: UIBarMetrics = .default) {
        self.styleContext = styleContext
        self.controlState = controlState
        self.barMetrics = barMetrics
    }
}

extension UIControl.State {

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
extension UIBarMetrics {

    init?(name: String) {
        switch name {
        case "default": self = .default
        case "defaultPrompt": self = .defaultPrompt
        case "compact": self = .compact
        case "compactPrompt": self = .compactPrompt
        default: return nil
        }
    }
}
