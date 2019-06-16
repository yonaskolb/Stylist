//
//  View.swift
//  Stylist
//
//  Created by Yonas Kolb on 4/6/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

extension UIResponder {

    var viewController: UIViewController? {
        return next as? UIViewController ?? next?.viewController
    }
}

extension View {

    static let styleObjects: [StyleObject] = {

        var objects: [StyleObject] = []

        func add<ViewType, StyleableType: Styleable>(_ name: String, _ styleable: @escaping (ViewType) -> StyleableType?) {
            objects.append(StyleObject(name: name, styleable: styleable))
        }

        add("superview") { (view: UIView) in
            view.superview
        }

        add("parent") { (view: UIView) in
            view.superview
        }

        add("next") { (view: UIView) -> UIView? in
            guard let superview = view.superview,
                let index = superview.subviews.firstIndex(of: view),
                index + 1 < superview.subviews.count else {
                return nil
            }
            return superview.subviews[index + 1]
        }

        add("previous") { (view: UIView) -> UIView? in
            guard let superview = view.superview,
                let index = superview.subviews.firstIndex(of: view),
                index - 1 >= 0 else {
                    return nil
            }
            return superview.subviews[index - 1]
        }

        add("viewController") { (view: UIView) in
            view.viewController
        }

        return objects
    }()

    static let styleProperties: [StyleProperty] = {

        var properties: [StyleProperty] = []

        func add<ViewType, PropertyType>(_ name: String, _ style: @escaping (ViewType, PropertyValue<PropertyType>) -> Void) {
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

        add("clipsToBounds") { (view: View, value: PropertyValue<Bool>) in
            view.clipsToBounds = value.value
        }

        // UIView Frame

        add("position") { (view: View, value: PropertyValue<CGPoint>) in
            view.frame.origin = value.value
        }

        add("origin") { (view: View, value: PropertyValue<CGPoint>) in
            view.frame.origin = value.value
        }

        add("size") { (view: View, value: PropertyValue<CGSize>) in
            view.frame.size = value.value
        }

        add("frame") { (view: View, value: PropertyValue<CGRect>) in
            view.frame = value.value
        }

        add("backgroundImagePattern") { (view: View, value: PropertyValue<UIImage>) in
            view.backgroundColor = UIColor(patternImage: value.value)
        }

        add("contentMode") { (view: UIView, value: PropertyValue<UIView.ContentMode>) in
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

        // Constraints

        add("widthAnchor") { (view: UIView, value: PropertyValue<LayoutAnchor>) in
            let anchor = value.value
            if let existingContraint = view.constraints.first(where: {
                $0.firstItem === view &&
                    $0.firstAttribute == .width &&
                    $0.secondItem == nil
            }) {
                existingContraint.isActive = false
            }

            let contraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: anchor.equality, toItem: nil, attribute: .height, multiplier: 1, constant: anchor.constant)

            contraint.isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        add("heightAnchor") { (view: UIView, value: PropertyValue<LayoutAnchor>) in
            let anchor = value.value
            if let existingContraint = view.constraints.first(where: {
                $0.firstItem === view &&
                    $0.firstAttribute == .height &&
                    $0.secondItem == nil
            }) {
                existingContraint.isActive = false
            }

            let contraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: anchor.equality, toItem: nil, attribute: .width, multiplier: 1, constant: anchor.constant)

            contraint.isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        add("aspectRatioAnchor") { (view: UIView, value: PropertyValue<AspectRatioAnchor>) in
            let anchor = value.value
            if let existingContraint = view.constraints.first(where: {
                $0.firstItem === view &&
                    $0.firstAttribute == .width &&
                    $0.secondItem === view &&
                    $0.secondAttribute == .height
            }) {
                existingContraint.isActive = false
            }

            let contraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .height, multiplier: value.value.ratio, constant: 0)
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

        add("font") { (view: UILabel, value: PropertyValue<Font>) in
            view.font = value.value
        }

        add("text") { (view: UILabel, value: PropertyValue<String>) in
            view.text = value.value
        }

        add("textAlignment") { (view: UILabel, value: PropertyValue<NSTextAlignment>) in
            view.textAlignment = value.value
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

        add("textAlignment") { (view: UITextView, value: PropertyValue<NSTextAlignment>) in
            view.textAlignment = value.value
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

        add("textAlignment") { (view: UITextField, value: PropertyValue<NSTextAlignment>) in
            view.textAlignment = value.value
        }

        // UISwitch
        #if os(iOS)
        add("onTintColor") { (view: UISwitch, value: PropertyValue<Color>) in
            view.onTintColor = value.value
        }

        add("thumbTintColor") { (view: UISwitch, value: PropertyValue<Color>) in
            view.thumbTintColor = value.value
        }
        #endif

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

        add("titleColor") { (view: UINavigationBar, value: PropertyValue<Color>) in
            var attributes = view.titleTextAttributes ?? [:]
            attributes[.foregroundColor] = value.value
            view.titleTextAttributes = attributes
        }

        add("titleFont") { (view: UINavigationBar, value: PropertyValue<Font>) in
            var attributes = view.titleTextAttributes ?? [:]
            attributes[.font] = value.value
            view.titleTextAttributes = attributes
        }

        add("titleTextAttributes") { (view: UINavigationBar, value: PropertyValue<TextAttributes>) in
            view.titleTextAttributes = value.value.attributes
        }

        add("translucent") { (view: UINavigationBar, value: PropertyValue<Bool>) in
            view.isTranslucent = value.value
        }

        #if os(iOS)

        if #available(iOS 11.0, *) {
            add("largeTitleColor") { (view: UINavigationBar, value: PropertyValue<Color>) in
                var attributes = view.largeTitleTextAttributes ?? [:]
                attributes[.foregroundColor] = value.value
                view.largeTitleTextAttributes = attributes
            }

            add("largeTitleFont") { (view: UINavigationBar, value: PropertyValue<Font>) in
                var attributes = view.largeTitleTextAttributes ?? [:]
                attributes[.font] = value.value
                view.largeTitleTextAttributes = attributes
            }

            add("prefersLargeTitles") { (view: UINavigationBar, value: PropertyValue<Bool>) in

                view.prefersLargeTitles = value.value
            }
        }

        add("barStyle") { (view: UINavigationBar, value: PropertyValue<UIBarStyle>) in
            view.barStyle = value.value
        }

        add("backIndicatorImage") { (view: UINavigationBar, value: PropertyValue<UIImage>) in
            view.backIndicatorImage = value.value
        }

        add("backIndicatorTransitionMaskImage") { (view: UINavigationBar, value: PropertyValue<UIImage>) in
            view.backIndicatorTransitionMaskImage = value.value
        }
        #endif

        add("shadowImage") { (view: UINavigationBar, value: PropertyValue<UIImage>) in
            view.shadowImage = value.value
        }

        add("backgroundImage") { (view: UINavigationBar, value: PropertyValue<UIImage>) in
            view.setBackgroundImage(value.value, for: value.context.barMetrics)
        }

        // UITabBar
        add("translucent") { (view: UITabBar, value: PropertyValue<Bool>) in
            view.isTranslucent = value.value
        }

        add("barTintColor") { (view: UITabBar, value: PropertyValue<Color>) in
            view.barTintColor = value.value
        }

        add("shadowImage") { (view: UITabBar, value: PropertyValue<UIImage>) in
            view.shadowImage = value.value
        }

        add("backgroundImage") { (view: UITabBar, value: PropertyValue<UIImage>) in
            view.backgroundImage = value.value
        }

        add("selectionIndicatorImage") { (view: UITabBar, value: PropertyValue<UIImage>) in
            view.selectionIndicatorImage = value.value
        }

        #if os(iOS)

        add("barStyle") { (view: UITabBar, value: PropertyValue<UIBarStyle>) in
            view.barStyle = value.value
        }

        add("itemPositioning") { (view: UITabBar, value: PropertyValue<UITabBar.ItemPositioning>) in
            view.itemPositioning = value.value
        }

        if #available(iOS 10.0, *) {
            add("unselectedItemTintColor") { (view: UITabBar, value: PropertyValue<Color>) in
                view.unselectedItemTintColor = value.value
            }
        }
        #endif

        // UISearchBar
        add("backgroundImage") { (view: UISearchBar, value: PropertyValue<UIImage>) in
            view.backgroundImage = value.value
        }

        // UIStackView
        add("spacing") { (view: UIStackView, value: PropertyValue<CGFloat>) in
            view.spacing = value.value
        }

        add("alignment") { (view: UIStackView, value: PropertyValue<UIStackView.Alignment>) in
            view.alignment = value.value
        }

        add("distribution") { (view: UIStackView, value: PropertyValue<UIStackView.Distribution>) in
            view.distribution = value.value
        }
        
        add("axis") { (view: UIStackView, value: PropertyValue<NSLayoutConstraint.Axis>) in
            view.axis = value.value
        }

        add("relativeMargins") { (view: UIStackView, value: PropertyValue<Bool>) in
            view.isLayoutMarginsRelativeArrangement = value.value
        }

        return properties
    }()
}
