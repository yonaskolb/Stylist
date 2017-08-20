//
//  Image.swift
//  Stylist
//
//  Created by Yonas Kolb on 19/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias Image = UIImage
#elseif os(macOS)
    import Cocoa
    public typealias Image = NSImage
#endif

extension Image: StyleValue {

    public static func parse(value: Any) -> Image? {
        guard let string = value as? String else { return nil }
        if string == "none" {
            return UIImage()
        }
        return UIImage(named: string)
    }
}
