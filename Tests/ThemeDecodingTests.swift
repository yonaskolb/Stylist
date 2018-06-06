//
//  ThemeDecodingTests.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/5/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import XCTest
@testable import Stylist
import Yams

class ThemeDecodingTests: XCTestCase {

    // to get around cross platform tests
    fileprivate let className = NSStringFromClass(ThemeDecodingTests.self)

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
                try StyleSelector(
                    selector: "header",
                    style: Style(properties: [
                        StylePropertyValue(name: "textColor", value: "blue:0.5"),
                    ])
                ),
            ]
        )
        XCTAssertEqual(theme, expectedTheme)
    }

    func testStyleInheriting() throws {
        let string = """
        styles:
          main:
            styles: [primary]
            color: green
          primary:
            tintColor: red
          header:
            styles: [main]
            textColor: blue
        """

        let theme = try Theme(string: string)

        let expectedTheme = Theme(
            styles: [
                try StyleSelector(selector: "header", style: Style(properties: [
                    StylePropertyValue(name: "color", value: "green"),
                    StylePropertyValue(name: "textColor", value: "blue"),
                    StylePropertyValue(name: "tintColor", value: "red"),
                    ])),
                try StyleSelector(selector: "main", style: Style(properties: [
                    StylePropertyValue(name: "color", value: "green"),
                    StylePropertyValue(name: "tintColor", value: "red"),
                    ])),
                try StyleSelector(selector: "primary", style: Style(properties: [
                    StylePropertyValue(name: "tintColor", value: "red"),
                    ])),
            ]
        )
        XCTAssertEqual(theme, expectedTheme)
    }

    func testSubStyles() throws {
        let string = """
        styles:
          primary:
            tintColor: red
            parent:
                tintColor: blue
                next:
                    tintColor: yellow
        """

        let theme = try Theme(string: string)

        let expectedTheme = Theme(
            styles: [
                try StyleSelector(
                    selector: "primary",
                    style: Style(
                        properties: [
                            StylePropertyValue(name: "tintColor", value: "red"),
                        ],
                        subStyles: [
                            "parent": Style(
                                properties: [StylePropertyValue(name: "tintColor", value: "blue")],
                                subStyles: [
                                    "next": Style(properties: [StylePropertyValue(name: "tintColor", value: "yellow")]),
                                ]
                            ),
                        ]
                    )
                ),
            ]
        )
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
                try StyleSelector(selector: "header", style: Style(properties: [
                    StylePropertyValue(
                        name: "textColor",
                        value: "blue:0.5",
                        context: PropertyContext(styleContext: .init(device: .pad), controlState: .selected)
                    ),
                ])),
            ]
        )
        XCTAssertEqual(theme, expectedTheme)
    }

    func testPropertyContextDecoding() throws {

        let values = try [
            StylePropertyValue(string: "textColor:selected(device:ipad)", value: "red"),
            StylePropertyValue(string: "textColor:compact(device:phone, h:regular)", value: "blue"),
            StylePropertyValue(string: "textColor(vertical:compact)", value: "blue"),
        ]

        let expectedValues = [
            StylePropertyValue(
                name: "textColor",
                value: "red",
                context: PropertyContext(styleContext: .init(device: .pad), controlState: .selected)
            ),
            StylePropertyValue(
                name: "textColor",
                value: "blue",
                context: PropertyContext(styleContext: .init(device: .phone, horizontalSizeClass: .regular), barMetrics: .compact)
            ),
            StylePropertyValue(
                name: "textColor",
                value: "blue",
                context: PropertyContext(styleContext: .init(verticalSizeClass: .compact))
            ),
        ]
        XCTAssertEqual(values, expectedValues)
    }

    func testStyleSelectorDecoding() throws {

        XCTAssertEqual(try SelectorComponent.components(from: "UIButton"), [
            SelectorComponent(classType: UIButton.self, style: nil),
        ])

        XCTAssertEqual(try SelectorComponent.components(from: "UIButton.red"), [
            SelectorComponent(classType: UIButton.self, style: "red"),
        ])

        XCTAssertEqual(try SelectorComponent.components(from: "\(className)"), [
            SelectorComponent(classType: ThemeDecodingTests.self, style: nil),
        ])

        XCTAssertEqual(try SelectorComponent.components(from: "\(className).red"), [
            SelectorComponent(classType: ThemeDecodingTests.self, style: "red"),
        ])

        XCTAssertEqual(try SelectorComponent.components(from: "UIButton primary"), [
            SelectorComponent(classType: UIButton.self, style: nil),
            SelectorComponent(classType: nil, style: "primary"),
        ])

        XCTAssertEqual(try SelectorComponent.components(from: "\(className).red UIButton"), [
            SelectorComponent(classType: ThemeDecodingTests.self, style: "red"),
            SelectorComponent(classType: UIButton.self, style: nil),
        ])
    }

    func testStyleContextDecoding() throws {
        let ids: [String] = [
            "color(device:pad)",
            "color(device: ipad)",
            "color(device:phone,h:regular)",
            "color(device: iphone, v: compact)",
        ]

        let contexts: [StyleContext] = try ids.map { try StyleContext.getContext(string: $0).context }

        let expectedContexts: [StyleContext] = [
            StyleContext(device: .pad),
            StyleContext(device: .pad),
            StyleContext(device: .phone, horizontalSizeClass: .regular),
            StyleContext(device: .phone, verticalSizeClass: .compact),
        ]

        XCTAssertEqual(contexts, expectedContexts)
    }

    func testThemeDecodingErrors() throws {

        func parseTheme(theme: String = "", style: String = "testStyle", property: String? = nil) throws {
            var theme = theme
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
            try parseTheme(property: "prop: $variable")
        }

        expectError(ThemeError.invalidStyleReference(style: "testStyle", reference: "invalid")) {
            try parseTheme(property: "styles: [invalid]")
        }

        expectError(ThemeError.invalidPropertyState(name: "color", state: "invalid")) {
            try parseTheme(property: "color:invalid: red")
        }

        expectError(ThemeError.invalidDevice(name: "color", device: "invalid")) {
            try parseTheme(property: "color(device:invalid): red")
        }

        expectError(ThemeError.invalidStyleContext("color(invalid)")) {
            try parseTheme(property: "color(invalid): red")
        }

        expectError(ThemeError.invalidStyleContext("color(invalid:ipad)")) {
            try parseTheme(property: "color(invalid:ipad): red")
        }

        expectError(ThemeError.invalidStyleSelector("InvalidClass")) {
            try parseTheme(style: "InvalidClass", property: "color: red")
        }

        expectError(ThemeError.invalidStyleSelector("Module.class.style.invalid")) {
            try parseTheme(style: "Module.class.style.invalid", property: "color: red")
        }

        expectError(ThemeError.invalidStyleSelector("Module.Invalid")) {
            try parseTheme(style: "Module.Invalid", property: "color: red")
        }

        expectError(ThemeError.styleReferenceCycle(references: ["one", "two"])) {
            try parseTheme(theme: """
                styles:
                    one:
                        styles: [two]
                    two:
                        styles: [one]
                """)
        }
    }

    func testStyleSpecificityIndex() throws {
        let styles = [
            try StyleSelector(selector: "UIView.custom primary", style: Style(properties: [])),
            try StyleSelector(selector: "UIView primary", style: Style(properties: [])),
            try StyleSelector(selector: "UIView", style: Style(properties: [])),
        ]
        let theme = Theme(variables: [:], styles: styles)
        XCTAssertEqual(theme.styles, styles.reversed())
    }

}
