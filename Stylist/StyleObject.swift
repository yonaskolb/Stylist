//
//  StyleObject.swift
//  Stylist
//
//  Created by Yonas Kolb on 4/6/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation

public struct StyleObject {

    public let name: String
    let getStyleable: (Any) -> Styleable?
    private let supports: (String, Any) -> Bool

    public init<ViewType, StyleableType: Styleable>(name: String, styleable: @escaping (ViewType) -> StyleableType?) {
        self.name = name
        getStyleable = { view in
            guard let view = view as? ViewType else { return nil }
            return styleable(view)
        }
        supports = { propertyName, styleable in
            propertyName == name && styleable is ViewType
        }
    }

    func canStyle(name: String, view: Any) -> Bool {
        return supports(name, view)
    }
}
