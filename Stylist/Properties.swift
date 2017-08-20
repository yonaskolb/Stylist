//
//  Properties.swift
//  Stylist
//
//  Created by Yonas Kolb on 20/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation
import UIKit

enum StyleProperties {

    static let view: [StyleProperty] = {

        var properties: [StyleProperty] = []

        func add<ViewType, PropertyType: StyleValue>(_ name: String, _ style: @escaping (ViewType, PropertyValue<PropertyType>) -> Void) {
            properties.append(StyleProperty(name: name, style: style))
        }

        // UIView

        add("backgroundColor") { (view: View, value: PropertyValue<Color>) in
            view.backgroundColor = value.value
        }

        add("tintColor") { (view: View, value: PropertyValue<Color>) in
            view.tintColor = value.value
        }

        add("alpha") { (view: View, value: PropertyValue<CGFloat>) in
            view.alpha = value.value
        }

        // Layer

        add("borderColor") { (view: View, value: PropertyValue<Color>) in
            view.layer.borderColor = value.value.cgColor
        }

        add("borderWidth") { (view: View, value: PropertyValue<CGFloat>) in
            view.layer.borderWidth = value.value
        }

        add("cornerRadius") { (view: View, value: PropertyValue<CGFloat>) in
            view.layer.cornerRadius = value.value
        }

        add("clipsToBounds") { (view: View, value: PropertyValue<Bool>) in
            view.clipsToBounds = value.value
        }

        add("shadowOpacity") { (view: View, value: PropertyValue<Float>) in
            view.layer.shadowOpacity = value.value
        }

        add("shadowColor") { (view: View, value: PropertyValue<Color>) in
            view.layer.shadowColor = value.value.cgColor
        }

        add("shadowOffset") { (view: View, value: PropertyValue<CGSize>) in
            view.layer.shadowOffset = value.value
        }

        add("shadowRadius") { (view: View, value: PropertyValue<CGFloat>) in
            view.layer.shadowRadius = value.value
        }

        add("backgroundImagePattern") { (view: View, value: PropertyValue<UIImage>) in
            view.backgroundColor = UIColor(patternImage: value.value)
        }

        add("contentMode") { (view: UIView, value: PropertyValue<UIViewContentMode>) in
            view.contentMode = value.value
        }

        add("visible") { (view: UIView, value: PropertyValue<Bool>) in
            view.isHidden = !value.value
        }
        add("hidden") { (view: UIView, value: PropertyValue<Bool>) in
            view.isHidden = value.value
        }

        add("layoutMargins") { (view: UIView, value: PropertyValue<UIEdgeInsets>) in
            view.layoutMargins = value.value
        }

        // Constraints

        add("widthAnchor") { (view: UIView, value: PropertyValue<LayoutAnchor>) in
            let anchor = value.value
            if let existingContraint = view.constraints.first(where: {$0.firstItem === view && $0.firstAttribute == .width && $0.relation == .equal }) {
                existingContraint.isActive = false
            }

            let contraint:NSLayoutConstraint
            if anchor.ratio {
                contraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: anchor.equality, toItem: view, attribute: .height, multiplier: anchor.constant, constant: 0)
            } else {
                contraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: anchor.equality, toItem: nil, attribute: .height, multiplier: 1, constant: anchor.constant)
            }

            contraint.isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        add("heightAnchor") { (view: UIView, value: PropertyValue<LayoutAnchor>) in
            let anchor = value.value
            if let existingContraint = view.constraints.first(where: {$0.firstItem === view && $0.firstAttribute == .height && $0.relation == .equal }) {
                existingContraint.isActive = false
            }

            let contraint:NSLayoutConstraint
            if anchor.ratio {
                contraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: anchor.equality, toItem: view, attribute: .width, multiplier: anchor.constant, constant: 0)
            } else {
                contraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: anchor.equality, toItem: nil, attribute: .width, multiplier: 1, constant: anchor.constant)
            }

            contraint.isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false
        }


        // UIImageView
        add("image") { (view: UIImageView, value: PropertyValue<UIImage>) in
            view.image = value.value
        }

        // UIButton

        add("backgroundImage") { (view: UIButton, value: PropertyValue<UIImage>) in
            view.setBackgroundImage(value.value, for: value.context.controlState)
        }

        add("imageEdgeInsets") { (view: UIButton, value: PropertyValue<UIEdgeInsets>) in
            view.imageEdgeInsets = value.value
        }

        add("titleEdgeInsets") { (view: UIButton, value: PropertyValue<UIEdgeInsets>) in
            view.titleEdgeInsets = value.value
        }

        add("contentEdgeInsets") { (view: UIButton, value: PropertyValue<UIEdgeInsets>) in
            view.contentEdgeInsets = value.value
        }

        add("textColor") { (view: UIButton, value: PropertyValue<Color>) in
            view.setTitleColor(value.value, for: value.context.controlState)
        }
        add("titleColor") { (view: UIButton, value: PropertyValue<Color>) in
            view.setTitleColor(value.value, for: value.context.controlState)
        }

        add("font") { (view: UIButton, value: PropertyValue<Font>) in
            view.titleLabel?.font = value.value
        }
        add("titleFont") { (view: UIButton, value: PropertyValue<Font>) in
            view.titleLabel?.font = value.value
        }

        // UILabel

        add("textColor") { (view: UILabel, value: PropertyValue<Color>) in
            view.textColor = value.value
        }

        add("textColor") { (view: UILabel, value: PropertyValue<Color>) in
            view.textColor = value.value
        }

        add("font") { (view: UILabel, value: PropertyValue<Font>) in
            view.font = value.value
        }

        add("text") { (view: UILabel, value: PropertyValue<String>) in
            view.text = value.value
        }

        // UITextView

        add("textColor") { (view: UITextView, value: PropertyValue<Color>) in
            view.textColor = value.value
        }

        add("font") { (view: UITextView, value: PropertyValue<Font>) in
            view.font = value.value
        }

        add("text") { (view: UITextView, value: PropertyValue<String>) in
            view.text = value.value
        }

        // UITextField

        add("textColor") { (view: UITextField, value: PropertyValue<Color>) in
            view.textColor = value.value
        }

        add("font") { (view: UITextField, value: PropertyValue<Font>) in
            view.font = value.value
        }

        add("text") { (view: UITextField, value: PropertyValue<String>) in
            view.text = value.value
        }

        // UIProgressBar
        add("progressTintColor") { (view: UIProgressView, value: PropertyValue<Color>) in
            view.progressTintColor = value.value
        }

        add("trackTintColor") { (view: UIProgressView, value: PropertyValue<Color>) in
            view.trackTintColor = value.value
        }

        // UINavigationBar
        add("barTintColor") { (view: UINavigationBar, value: PropertyValue<Color>) in
            view.barTintColor = value.value
        }

        add("translucent") { (view: UINavigationBar, value: PropertyValue<Bool>) in
            view.isTranslucent = value.value
        }

        add("barStyle") { (view: UINavigationBar, value: PropertyValue<UIBarStyle>) in
            view.barStyle = value.value
        }

        add("shadowImage") { (view: UINavigationBar, value: PropertyValue<UIImage>) in
            view.shadowImage = value.value
        }

        add("backgroundImage") { (view: UINavigationBar, value: PropertyValue<UIImage>) in
            view.setBackgroundImage(value.value, for: value.context.barMetrics)
        }

        // UISearchBar
        add("backgroundImage") { (view: UISearchBar, value: PropertyValue<UIImage>) in
            view.backgroundImage = value.value
        }
        
        // UIStackView
        add("spacing") { (view: UIStackView, value: PropertyValue<CGFloat>) in
            view.spacing = value.value
        }

        add("alignment") { (view: UIStackView, value: PropertyValue<UIStackViewAlignment>) in
            view.alignment = value.value
        }

        add("distribution") { (view: UIStackView, value: PropertyValue<UIStackViewDistribution>) in
            view.distribution = value.value
        }

        add("axis") { (view: UIStackView, value: PropertyValue<UILayoutConstraintAxis>) in
            view.axis = value.value
        }

        add("relativeMargins") { (view: UIStackView, value: PropertyValue<Bool>) in
            view.isLayoutMarginsRelativeArrangement = value.value
        }

        return properties
    }()

    static let barItem: [StyleProperty] = {

        var properties: [StyleProperty] = []

        func add<ViewType, PropertyType: StyleValue>(_ name: String, _ style: @escaping (ViewType, PropertyValue<PropertyType>) -> Void) {
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

        return properties
    }()
    
}
