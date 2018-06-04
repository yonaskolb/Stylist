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

    func applyStyles() {
        Stylist.shared.style(self)
    }

    fileprivate func setStyle(_ style: String?) {
        styles = style?.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) } ?? []
    }

    fileprivate func getStyle() -> String? {
        return styles.isEmpty ? nil : styles.joined(separator: ",")
    }
}

extension UIView: Styleable {

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
            applyStyles()
        }
    }

    @IBInspectable
    open var style: String? {
        get {
            return getStyle()
        }
        set {
            setStyle(newValue)
        }
    }

}

extension UIViewController: Styleable {

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
            applyStyles()
        }
    }

    @IBInspectable
    open var style: String? {
        get {
            return getStyle()
        }
        set {
            setStyle(newValue)
        }
    }

}

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
            applyStyles()
        }
    }

    @IBInspectable
    open var style: String? {
        get {
            return getStyle()
        }
        set {
            setStyle(newValue)
        }
    }

}
