//
//  ThemeError.swift
//  Stylist
//
//  Created by Yonas Kolb on 22/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation

public enum ThemeError: Error, Equatable {
    case notFound
    case decodingError
    case invalidVariable(name: String, variable: String)
    case invalidStyleReference(style: String, reference: String)
    case invalidPropertyState(name: String, state: String)
    case invalidDevice(name: String, device: String)
    case invalidStyleContext(String)
}
