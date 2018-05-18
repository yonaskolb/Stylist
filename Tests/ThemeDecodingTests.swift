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

        func expectError(theme string: String, expectedError: ThemeError, file: StaticString = #file, line: UInt = #line) {
            do {
                let theme = try Theme(string: string)
                XCTFail("Theme decoded \(theme) but was supposed to fail with error \(expectedError)", file: file, line: line)
            } catch let error as ThemeError {
                XCTAssertEqual(error, expectedError, file: file, line: line)
            } catch {
                XCTFail("Theme failed decoding with error \(error) but expected error \(expectedError)", file: file, line: line)
            }
        }

        func theme(style: String = "testStyle", property: String? = nil, variable: String? = nil) -> String {
            var theme = ""
            if let variable = variable {
                theme += "\nvariables:\n  \(variable)"
            }
            if let property = property {
                theme += "\nstyles:\n  \(style):\n    \(property)"
            }
            return theme
        }

        expectError(theme: "^&*@#$", expectedError: ThemeError.decodingError)
        expectError(theme: theme(property: "prop: $variable", variable: "var: red"), expectedError: ThemeError.invalidVariable(name:
            "prop", variable: "variable"))
        expectError(theme: theme(property: "prop: $variable"), expectedError: ThemeError.invalidVariable(name:
            "prop", variable: "variable"))
    }
    
}
