//
//  BarItem.swift
//  Stylist
//
//  Created by Yonas Kolb on 4/6/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation
import UIKit

extension UIBarItem {

    static let styleProperties: [StyleProperty] = {

        var properties: [StyleProperty] = []

        func add<ViewType, PropertyType>(_ name: String, _ style: @escaping (ViewType, PropertyValue<PropertyType>) -> Void) {
            properties.append(StyleProperty(name: name, style: style))
        }

        // UIBarItem
        add("image") { (view: UIBarItem, value: PropertyValue<Image>) in
            view.image = value.value
        }

        // UIBarButtonItem
        add("tintColor") { (view: UIBarButtonItem, value: PropertyValue<Color>) in
            view.tintColor = value.value
        }

        // UITabBarItem
        add("selectedImage") { (view: UITabBarItem, value: PropertyValue<Image>) in
            view.selectedImage = value.value
        }

        add("titlePositionAdjustment") { (view: UITabBarItem, value: PropertyValue<UIOffset>) in
            view.titlePositionAdjustment = value.value
        }

        #if os(iOS)
        if #available(iOS 10.0, *) {
            add("badgeColor") { (view: UITabBarItem, value: PropertyValue<Color>) in
                view.badgeColor = value.value

            }
        }
        #endif

        return properties
    }()
}
