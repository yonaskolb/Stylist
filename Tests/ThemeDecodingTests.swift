//
//  ThemeDecodingTests.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/5/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import XCTest
@testable import Stylist
import XCTest
import Yams

class ThemeDecodingTests: XCTestCase {

    func testVariableSubstitution() throws {
        let string = """
        variables:
          primaryColor: blue
        styles:
          header:
            textColor: $primaryColor:0.5
        """

        let theme = try Theme(string: string)

        let expectedTheme = Theme(
            variables: ["primaryColor": "blue"],
            styles: [
                Style(name: "header", properties: [
                    StylePropertyValue(name: "textColor", value: "blue:0.5")
                    ])
            ])
        XCTAssertEqual(theme, expectedTheme)
    }

    func testThemeYamlDecoding() throws {
        let string = """
        variables:
          primaryColor: blue
        styles:
          header:
            textColor:selected(device:ipad): $primaryColor:0.5
        """

        let theme = try Theme(string: string)

        let expectedTheme = Theme(
            variables: ["primaryColor": "blue"],
            styles: [
                Style(name: "header", properties: [
                    StylePropertyValue(name: "textColor",
                                       value: "blue:0.5",
                                       context: PropertyContext(device: .pad, controlState: .selected))
                    ])
            ])
        XCTAssertEqual(theme, expectedTheme)
    }

    func testPropertyContextDecoding() throws {

        let values = try [
            StylePropertyValue(id: "textColor:selected(device:ipad)", value: "red")
        ]

        let expectedValues = [
            StylePropertyValue(name: "textColor",
                               value: "red",
                               context: PropertyContext(device: .pad, controlState: .selected))
        ]
        XCTAssertEqual(values, expectedValues)
    }

    func testThemeDecodingErrors() throws {

        func themeString(style: String = "testStyle", property: String? = nil) throws {
            var theme = ""
            if let property = property {
                theme += "\nstyles:\n  \(style):\n    \(property)"
            }
            _ = try Theme(string: theme)
        }

        expectError(ThemeError.notFound) {
            _ = try Theme(path: "invalid")
        }

        expectError(ThemeError.decodingError) {
            _ = try Theme(string: "^&*@#$")
        }

        expectError(ThemeError.invalidVariable(name: "prop", variable: "variable")) {
            try themeString(property: "prop: $variable")
        }

        expectError(ThemeError.invalidStyleReference(style: "testStyle", reference: "invalid")) {
           try themeString(property: "styles: [invalid]")
        }

        expectError(ThemeError.invalidControlState(name: "color", controlState: "invalid")) {
            try themeString(property: "color:invalid: red")
        }

        expectError(ThemeError.invalidDevice(name: "color", device: "invalid")) {
            try themeString(property: "color(device:invalid): red")
        }

//        expectError(ThemeError.invalidBarMetrics(name: "color", barMetrics: "invalid")) {
//            try themeString(property: "color(barMetrics:invalid): red")
//        }
    }
    
}
