//
//  Stylist.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation
import UIKit

public class Stylist {

    public static let shared = Stylist()

    var viewStyles: [String: [WeakContainer<UIView>]] = [:]

    var theme: Theme?

    init() {

    }

    func clear() {
        viewStyles = [:]
    }

    func setStyles(view: UIView, styles: [String]) {
        for style in styles {
            var views: [WeakContainer<UIView>]
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
                if let attributes = theme.getAttributes(style) {
                    for attribute in attributes {
                        apply(attribute: attribute, view: view)
                    }
                }
            }
        }
    }

    func getStyles(view: UIView) -> [String] {
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
                    for attribute in style.attributes {
                        apply(attribute: attribute, view: view)
                    }
                }
            }
        }
    }

    func apply(attribute: StyleAttribute, view: UIView) {
        switch attribute.attribute {
        case .backgroundColor(let color): view.backgroundColor = color
        case .cornerRadius(let radius): view.layer.cornerRadius = CGFloat(radius)
        case .borderColor(let color): view.layer.borderColor = color.cgColor
        case .borderWidth(let width): view.layer.borderWidth = CGFloat(width)
        case .alpha(let alpha): view.alpha = CGFloat(alpha)
        case .shadowAlpha(let alpha): view.layer.shadowOpacity = Float(alpha)
        case .backgroundImage(let image):
            if let view = view as? UIButton {
                view.setBackgroundImage(image, for: attribute.controlState)
            }
        case .textColor(let color):
            if let view = view as? UILabel {
                view.textColor = color
            } else if let view = view as? UITextView {
                view.textColor = color
            } else if let view = view as? UITextField {
                view.textColor = color
            } else if let view = view as? UIButton {
                view.setTitleColor(color, for: attribute.controlState)
            }
        case .font(let font):
            if let view = view as? UILabel {
                view.font = font
            } else if let view = view as? UITextView {
                view.font = font
            } else if let view = view as? UITextField {
                view.font = font
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
