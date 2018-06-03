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
    public override var style: String? {
        get {
            return super.style
        }
        set {
            super.style = newValue
        }
    }
}
