//
//  Swift.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/5/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation

extension Bool: StyleValue {

    public static func parse(value: Any) -> Bool? {
        if let string = value as? String {
            switch string.lowercased() {
            case "yes", "true": return true
            case "no", "false": return false
            default: break
            }
        }
        return value as? Bool
    }
}

extension String: StyleValue {
    public static func parse(value: Any) -> String? {
        return value as? String
    }
}

extension Int: StyleValue {

    public static func parse(value: Any) -> Int? {
        if let string = value as? String {
            return Int(string)
        }
        return value as? Int
    }
}

extension Double: StyleValue {

    public static func parse(value: Any) -> Double? {
        if let int = value as? Int {
            return Double(int)
        } else if let string = value as? String {
            return Double(string)
        }
        return value as? Double
    }
}

extension Float: StyleValue {

    public static func parse(value: Any) -> Float? {
        if let float = value as? Float {
            return float
        } else if let int = value as? Int {
            return Float(int)
        } else if let string = value as? String {
            return Float(string)
        } else if let double = value as? Double {
            return Float(double)
        }
        return nil
    }
}
