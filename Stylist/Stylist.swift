//
//  Stylist.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation

public class Stylist {

    public static let shared = Stylist()

    var viewStyles: [String: [WeakContainer<NSObject>]] = [:]

    var properties: [StyleProperty] = []

    public var theme: Theme?

    init() {
        properties += StyleProperties.view
    }

    public func addProperty<ViewType, PropertyType: StyleValue>(_ name: String, viewType: ViewType.Type, propertyType: PropertyType.Type, _ style: @escaping (ViewType, PropertyValue<PropertyType>) -> Void) {
        properties.append(StyleProperty(name: name, style: style))
    }

    public func addProperty<ViewType, PropertyType: StyleValue>(_ name: String, _ style: @escaping (ViewType, PropertyValue<PropertyType>) -> Void) {
        properties.append(StyleProperty(name: name, style: style))
    }


    public func addProperty(_ property: StyleProperty) {
        properties.append(property)
    }

    func clear() {
        viewStyles = [:]
    }

    func setStyles(view: NSObject, styles: [String]) {
        for style in styles {
            var views: [WeakContainer<NSObject>]
            if let existingViews = viewStyles[style] {
                views = existingViews.filter{ $0.value != nil }
            } else {
                views = []
            }

            if !views.contains(where: { $0.value! === view}) {
                views.append(WeakContainer(view))
            }
            viewStyles[style] = views
        }

        if let theme = theme {
            for style in styles {
                if let style = theme.getStyle(style) {
                    apply(view: view, style: style)
                }
            }
        }
    }

    func apply(view: Any, style: Style) {
        for styleProperty in style.properties {

            guard styleProperty.context.isValidDevice else { continue }

            let properties = getValidProperties(name: styleProperty.name, view: view)
            for property in properties {
                do {
                    try property.apply(view, styleProperty)
                } catch {
                    print("Error applying property: \(error)")
                }
            }
        }
        if let view = view as? View, let parent = view.superview, let parentStyle = style.parentStyle {
            apply(view: parent, style: parentStyle)
        }
    }

    func getValidProperties(name: String, view: Any) -> [StyleProperty] {
        return properties.filter { $0.canStyle(name: name, view: view) }
    }

    func getStyles(view: NSObject) -> [String] {
        var styles: [String] = []
        for (style, views) in viewStyles {
            for viewContainer in views {
                if let value = viewContainer.value, value === view {
                    styles.append(style)
                }
            }
        }
        return styles
    }

    public func apply(theme: Theme) {
        self.theme = theme
        for style in theme.styles {
            if let views = viewStyles[style.name] {
                for view in views.flatMap({$0.value}) {
                    apply(view: view, style: style)
                }
            }
            for property in style.properties {
                if !properties.contains(where: {$0.name == property.name}) {
                    print("Theme contains unknown property: \(property.name)")
                }
            }
        }
    }
}

struct WeakContainer<T> where T: AnyObject {
    weak var value : T?

    init(_ value: T) {
        self.value = value
    }
}
