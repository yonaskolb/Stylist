//
//  StyleAttribute.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation
import UIKit

public typealias Color = UIColor

public enum StyleAttribute {
    case backgroundColor(Color)
    case cornerRadius(Int)
    case borderColor(Color)
    case borderWidth(Int)
    case alpha(Double)
    case shadowAlpha(Double)
    case image(UIImage)
    case textColor(Color)
    case font(UIFont)
}
