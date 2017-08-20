//
//  Styles.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias View = UIView
#elseif os(macOS)
    import Cocoa
    public typealias View = NSView
#endif

#if os(iOS) || os(tvOS)
extension View {

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
#endif
