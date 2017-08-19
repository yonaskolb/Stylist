//
//  Styles.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    @IBInspectable public var styles: [String] {
        get {
            return Stylist.shared.getStyles(view: self)
        }
        set {
            Stylist.shared.setStyles(view: self, styles: newValue)
        }
    }

    @IBInspectable public var style: String? {
        get {
            return Stylist.shared.getStyles(view: self).first
        }
        set {
            Stylist.shared.setStyles(view: self, styles: newValue != nil ? [newValue!] : [])
        }
    }
}

extension UIBarItem {

    @IBInspectable public var styles: [String] {
        get {
            return Stylist.shared.getStyles(view: self)
        }
        set {
            Stylist.shared.setStyles(view: self, styles: newValue)
        }
    }

    @IBInspectable public var style: String? {
        get {
            return Stylist.shared.getStyles(view: self).first
        }
        set {
            Stylist.shared.setStyles(view: self, styles: newValue != nil ? [newValue!] : [])
        }
    }
}

extension UIAppearance {

    func apply(style: Style) {
        style.attributes.forEach(apply)
    }

    func apply(styleAttribute: StyleAttribute) {
        switch styleAttribute.attribute {
        case .backgroundColor(let color):
            if let view = self as? UIView {
                view.backgroundColor = color
            }
        case .cornerRadius(let radius):
            if let view = self as? UIView {
                view.layer.cornerRadius = CGFloat(radius)
            }

        case .borderColor(let color):
            if let view = self as? UIView {
                view.layer.borderColor = color.cgColor
            }

        case .borderWidth(let width):
            if let view = self as? UIView {
                view.layer.borderWidth = CGFloat(width)
            }

        case .alpha(let alpha):
            if let view = self as? UIView {
                view.alpha = CGFloat(alpha)
            }

        case .shadowAlpha(let alpha):
            if let view = self as? UIView {
                view.layer.shadowOpacity = Float(alpha)
            }
        case .backgroundImage(let image):
            if let view = self as? UIButton {
                view.setBackgroundImage(image, for: styleAttribute.controlState)
            }
        case .textColor(let color):
            if let view = self as? UILabel {
                view.textColor = color
            } else if let view = self as? UITextView {
                view.textColor = color
            } else if let view = self as? UITextField {
                view.textColor = color
            } else if let view = self as? UIButton {
                view.setTitleColor(color, for: styleAttribute.controlState)
            }
        case .font(let font):
            if let view = self as? UILabel {
                view.font = font
            } else if let view = self as? UITextView {
                view.font = font
            } else if let view = self as? UITextField {
                view.font = font
            }
        }
    }
}
