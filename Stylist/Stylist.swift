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

    var viewStyles: [String: [WeakContainer<UIAppearance>]] = [:]

    public var theme: Theme?

    init() {

    }

    func clear() {
        viewStyles = [:]
    }

    func setStyles(view: UIAppearance, styles: [String]) {
        for style in styles {
            var views: [WeakContainer<UIAppearance>]
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
                    view.apply(style: style)
                }
            }
        }
    }

    func getStyles(view: UIAppearance) -> [String] {
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
                    view.apply(style: style)
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
