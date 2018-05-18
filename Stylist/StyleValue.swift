//
//  StyleValue.swift
//  Stylist
//
//  Created by Yonas Kolb on 20/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation

public protocol StyleValue {
    associatedtype ParsedType
    static func parse(value: Any) -> ParsedType?
}
