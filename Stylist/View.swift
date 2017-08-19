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

    public func style(with attributes: [StyleAttribute]) {
        for attribute in attributes {
            Stylist.shared.apply(attribute: attribute, view: self)
        }
    }
}
