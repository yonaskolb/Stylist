//
//  SectionView.swift
//  Example
//
//  Created by Yonas Kolb on 23/5/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SectionView: UIStackView {

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
