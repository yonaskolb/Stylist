//
//  StyleableView.swift
//  Stylist
//
//  Created by Yonas Kolb on 1/6/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class StyleableView: UIView {

    @IBInspectable
    public var style: String? {
        get {
            return styles.first
        }
        set {
            styles = newValue != nil ? [newValue!] : []
        }
    }
}
