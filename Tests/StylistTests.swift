//
//  StylistTests.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation
@testable import Stylist
import XCTest
import Yams

class StylistTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Stylist.shared.clear()
    }

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

    func testThemeDecoding() throws {
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

        let propertyValue = try StylePropertyValue(id: "textColor:selected(device:ipad)", value: "red")
        let expectedPropertyValue = StylePropertyValue(name: "textColor",
                                       value: "red",
                                       context: PropertyContext(device: .pad, controlState: .selected))
        XCTAssertEqual(propertyValue, expectedPropertyValue)
    }

    func testApplyStyle() throws {
        let stylist = Stylist()

        let style = Style(name: "blueBack", properties: [
                StylePropertyValue(name: "backgroundColor", value: "blue")
                ])

        let view = UIView()
        stylist.apply(styleable: view, style: style)
        XCTAssertEqual(view.backgroundColor, .blue)
    }

    func testSetStylesWithCustomStylist() throws {
        let stylist = Stylist()

        let theme = Theme(styles: [
                Style(name: "blueBack", properties: [
                    StylePropertyValue(name: "backgroundColor", value: "blue")
                    ]),
                Style(name: "rounded", properties: [
                    StylePropertyValue(name: "cornerRadius", value: 10)
                    ])
            ])

        stylist.addTheme(theme, name: "theme")
        let view = UIView()
        stylist.setStyles(styleable: view, styles: ["blueBack", "rounded"])

        XCTAssertEqual(view.backgroundColor, .blue)
        XCTAssertEqual(view.layer.cornerRadius, 10)

        let secondTheme = Theme(styles: [
            Style(name: "blueBack", properties: [
                StylePropertyValue(name: "backgroundColor", value: "red")
                ]),
            Style(name: "rounded", properties: [
                StylePropertyValue(name: "cornerRadius", value: 5)
                ])
            ])

        stylist.addTheme(secondTheme, name: "theme")
        
        XCTAssertEqual(view.backgroundColor, .red)
        XCTAssertEqual(view.layer.cornerRadius, 5)
    }

    func testSetStyles() throws {

        let theme = Theme(styles: [
            Style(name: "blueBack", properties: [
                StylePropertyValue(name: "backgroundColor", value: "blue")
                ]),
            Style(name: "rounded", properties: [
                StylePropertyValue(name: "cornerRadius", value: 10)
                ])
            ])

        Stylist.shared.addTheme(theme, name: "theme")
        let view = UIView()
        view.styles = ["blueBack", "rounded"]

        XCTAssertEqual(view.backgroundColor, .blue)
        XCTAssertEqual(view.layer.cornerRadius, 10)

        let secondTheme = Theme(styles: [
            Style(name: "blueBack", properties: [
                StylePropertyValue(name: "backgroundColor", value: "red")
                ]),
            Style(name: "rounded", properties: [
                StylePropertyValue(name: "cornerRadius", value: 5)
                ])
            ])

        Stylist.shared.addTheme(secondTheme, name: "theme")

        XCTAssertEqual(view.backgroundColor, .red)
        XCTAssertEqual(view.layer.cornerRadius, 5)
    }

    func testThemeErrors() throws {

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
                theme += """
                
                variables:
                  \(variable)
                """
            }
            if let property = property {
                theme += """

                styles:
                  \(style):
                    \(property)
                """
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
