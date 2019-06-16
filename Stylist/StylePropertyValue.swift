//
//  StylePropertyValue.swift
//  Stylist
//
//  Created by Yonas Kolb on 21/5/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation
import UIKit

struct StylePropertyValue: Equatable {
    let name: String
    let value: Any
    let context: PropertyContext

    init(name: String, value: Any, context: PropertyContext = PropertyContext()) {
        self.name = name
        self.value = value
        self.context = context
    }

    init(string: String, value: Any) throws {

        var (propertyName, styleContext) = try StyleContext.getContext(string: string)

        var controlState: UIControl.State = .normal
        var barMetrics: UIBarMetrics = .default

        let nameParts = propertyName.components(separatedBy: ":")
        propertyName = nameParts[0]

        if nameParts.count == 2 {
            let string = nameParts[1]
            if let parsedControlState = UIControl.State(name: string) {
                controlState = parsedControlState
            } else if let parsedBarMetrics = UIBarMetrics(name: string) {
                barMetrics = parsedBarMetrics
            } else {
                throw ThemeError.invalidPropertyState(name: propertyName, state: string)
            }
        }
        let context = PropertyContext(styleContext: styleContext, controlState: controlState, barMetrics: barMetrics)
        self.init(name: propertyName, value: value, context: context)
    }

    public static func == (lhs: StylePropertyValue, rhs: StylePropertyValue) -> Bool {
        return lhs.name == rhs.name
            && lhs.context == rhs.context
            && String(describing: lhs.value) == String(describing: rhs.value)
    }
}
