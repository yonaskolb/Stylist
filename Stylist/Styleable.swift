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

public protocol Styleable: class {
    var styles: [String] { get set }
}

extension Styleable {

    public var styles: [String] {
        get {
            return Stylist.shared.getStyles(styleable: self)
        }
        set {
            Stylist.shared.setStyles(styleable: self, styles: newValue)
        }
    }
}

extension View: Styleable {

    @IBInspectable public var style: String? {
        get {
            return Stylist.shared.getStyles(styleable: self).first
        }
        set {
            Stylist.shared.setStyles(styleable: self, styles: newValue != nil ? [newValue!] : [])
        }
    }
}

#if os(iOS) || os(tvOS)
    extension UIBarItem: Styleable {

        @IBInspectable public var style: String? {
            get {
                return Stylist.shared.getStyles(styleable: self).first
            }
            set {
                Stylist.shared.setStyles(styleable: self, styles: newValue != nil ? [newValue!] : [])
            }
        }
    }
#endif
