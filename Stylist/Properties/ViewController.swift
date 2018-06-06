//
//  ViewController.swift
//  Stylist
//
//  Created by Yonas Kolb on 4/6/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    static let styleObjects: [StyleObject] = {

        var objects: [StyleObject] = []

        func add<ViewType, StyleableType: Styleable>(_ name: String, _ styleable: @escaping (ViewType) -> StyleableType?) {
            objects.append(StyleObject(name: name, styleable: styleable))
        }

        add("tabBarController") { (viewController: UIViewController) in
            viewController as? UITabBarController ?? viewController.tabBarController
        }

        add("navigationController") { (viewController: UIViewController) in
            viewController as? UINavigationController ?? viewController.navigationController
        }

        add("tabBar") { (viewController: UIViewController) in
            (viewController as? UITabBarController ?? viewController.tabBarController)?.tabBar
        }
        
        add("navigationBar") { (viewController: UIViewController) in
            (viewController as? UINavigationController ?? viewController.navigationController)?.navigationBar
        }

        add("parent") { (viewController: UIViewController) in
            viewController.parent
        }

        add("view") { (viewController: UIViewController) in
            viewController.view
        }

        #if os(iOS)

        add("toolBar") { (viewController: UIViewController) in
            (viewController as? UINavigationController ?? viewController.navigationController)?.toolbar
        }

        add("toolbar") { (viewController: UIViewController) in
            (viewController as? UINavigationController ?? viewController.navigationController)?.toolbar
        }
        #endif

        return objects
    }()

    static let styleProperties: [StyleProperty] = {

        var properties: [StyleProperty] = []

        func add<ViewType, PropertyType>(_ name: String, _ style: @escaping (ViewType, PropertyValue<PropertyType>) -> Void) {
            properties.append(StyleProperty(name: name, style: style))
        }

        #if os(iOS)
        if #available(iOS 11.0, *) {

            add("largeTitleDisplayMode") { (viewController: UIViewController, value: PropertyValue<UINavigationItem.LargeTitleDisplayMode>) in
                viewController.navigationItem.largeTitleDisplayMode = value.value
            }

            add("largeTitleDisplayMode") { (viewController: UIViewController, value: PropertyValue<UINavigationItem.LargeTitleDisplayMode>) in
                viewController.navigationItem.largeTitleDisplayMode = value.value
            }
        }
        #endif

        return properties
    }()
}
