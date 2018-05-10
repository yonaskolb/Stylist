//
//  StyleProperty.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation

public struct StyleProperty {

    public let name: String
    let apply: (Any, StylePropertyValue) throws -> Void
    private let supports: (String, Any) -> Bool

    public init<ViewType, PropertyType>(name: String, style: @escaping (ViewType, PropertyValue<PropertyType>) -> Void) {
        self.name = name
        apply = { view, value in
            if let view = view as? ViewType {

                if let parsedValue = PropertyType.parse(value: value.value) {
                    let propertyValue = PropertyValue(value: parsedValue as! PropertyType, context: value.context)
                    style(view, propertyValue)
                } else {
                    throw StylePropertyError.parsingError(PropertyType.self, value.value)
                }
            }
        }
        supports = { otherName, view in
            otherName == name && view is ViewType
        }
    }

    public init<ViewType, PropertyType>(name: String, view: ViewType.Type, property: PropertyType.Type, style: @escaping (ViewType, PropertyValue<PropertyType>) -> Void) {
        self.init(name: name, style: style)
    }

    func canStyle(name: String, view: Any) -> Bool {
        return supports(name, view)
    }
}

public struct PropertyValue<T: StyleValue> {
    public let value: T
    public let context: PropertyContext
}

enum StylePropertyError: Error {
    case parsingError(Any.Type, Any)
    case incorrectControlState(String)
    case incorrectDevice(String)
}
