//
//  UIViewSwizzle.swift
//  Stylist
//
//  Created by Yonas Kolb on 22/5/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    class func setupSwizzling() {
        struct Static {
            static var swizzled = false
        }

        if Static.swizzled {
            return
        } else {
            Static.swizzled = true
        }

        if self !== UIView.self { return }

        let originalSelector = #selector(willMove(toSuperview:))
        let swizzledSelector = #selector(stylist_willMove(toSuperview:))

        let originalMethod = class_getInstanceMethod(UIView.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(UIView.self, swizzledSelector)
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }

    @objc func stylist_willMove(toSuperview: UIView) {
        stylist_willMove(toSuperview: toSuperview)
        Stylist.shared.style(self)
    }
}
