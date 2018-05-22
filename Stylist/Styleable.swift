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

    func applyStyles(_ styles: [String]) {
        Stylist.shared.setStyles(styleable: self, styles: styles)
    }
}

extension View: Styleable {

    struct AssociatedKeys {
        static var Styles = "stylist_styles"
    }

    public var styles: [String] {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.Styles) as? [String] ?? []
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.Styles,
                                     newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            applyStyles(newValue)
        }
    }

    @IBInspectable public var style: String? {
        get {
            return styles.first
        }
        set {
            styles = newValue != nil ? [newValue!] : []
        }
    }
}

#if os(iOS) || os(tvOS)
    extension UIBarItem: Styleable {

        struct AssociatedKeys {
            static var Styles = "stylist_styles"
        }

        public var styles: [String] {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.Styles) as? [String] ?? []
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.Styles,
                                         newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                applyStyles(newValue)
            }
        }

        @IBInspectable public var style: String? {
            get {
                return styles.first
            }
            set {
                styles = newValue != nil ? [newValue!] : []
            }
        }
    }
#endif
