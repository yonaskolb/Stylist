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
        XCTAssertEqual(stylist.themes["theme"], theme)

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

    func testSettingStyles() {
        let view = UIView()
        view.style = "test"
        XCTAssertEqual(view.style, "test")
        XCTAssertEqual(view.styles, ["test"])
        view.styles = ["one", "two"]
        //XCTAssertEqual(view.styles, ["one", "two"])
        //XCTAssertEqual(view.style, "one")
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

    //TODO test loading files

    //TODO: test watching files

    //TODO: test set correct style property based on PropertyContext

    //TODO: test custom property

    //TODO: test shared styles

    //TODO: test custom Styleable

    //TODO: test UIBarItem

    //TODO: test all default properties

}
