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

        let style = try Style(selector: "blueBack", properties: [
                StylePropertyValue(name: "backgroundColor", value: "blue")
                ])

        let view = UIView()
        stylist.apply(styleable: view, style: style)
        XCTAssertEqual(view.backgroundColor, .blue)
    }

    func testSetStylesWithCustomStylist() throws {
        let stylist = Stylist()

        let theme = Theme(styles: [
                try Style(selector: "blueBack", properties: [
                    StylePropertyValue(name: "backgroundColor", value: "blue")
                    ]),
                try Style(selector: "rounded", properties: [
                    StylePropertyValue(name: "cornerRadius", value: 10)
                    ])
            ])

        stylist.addTheme(theme, name: "theme")
        XCTAssertEqual(stylist.themes["theme"], theme)

        let view = UIView()
        view.styles = ["blueBack", "rounded"]
        stylist.style(view)

        XCTAssertEqual(view.backgroundColor, .blue)
        XCTAssertEqual(view.layer.cornerRadius, 10)

        let secondTheme = Theme(styles: [
            try Style(selector: "blueBack", properties: [
                StylePropertyValue(name: "backgroundColor", value: "red")
                ]),
            try Style(selector: "rounded", properties: [
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
        XCTAssertEqual(view.styles, ["one", "two"])
        XCTAssertEqual(view.style, "one")
    }

    func testFilteringSizeClasses() throws {

        let view = UIView()
        let traitCollection = UITraitCollection(horizontalSizeClass: .compact)
        TraitViewController.addTraits([traitCollection], to: view)

        let style = try Style(selector: "style", properties: [
            StylePropertyValue(name: "backgroundColor", value: "green", context: PropertyContext(styleContext: .init(horizontalSizeClass: .compact))),
            StylePropertyValue(name: "backgroundColor", value: "red", context: PropertyContext(styleContext: .init(horizontalSizeClass: .regular)))
            ])
        Stylist.shared.apply(styleable: view, style: style)

        XCTAssertEqual(view.backgroundColor, .green)
    }

    func testSetStyles() throws {

        let theme = Theme(styles: [
            try Style(selector: "blueBack", properties: [
                StylePropertyValue(name: "backgroundColor", value: "blue")
                ]),
            try Style(selector: "rounded", properties: [
                StylePropertyValue(name: "cornerRadius", value: 10)
                ])
            ])

        Stylist.shared.addTheme(theme, name: "theme")
        let view = UIView()
        view.styles = ["blueBack", "rounded"]

        XCTAssertEqual(view.backgroundColor, .blue)
        XCTAssertEqual(view.layer.cornerRadius, 10)

        let secondTheme = Theme(styles: [
            try Style(selector: "blueBack", properties: [
                StylePropertyValue(name: "backgroundColor", value: "red")
                ]),
            try Style(selector: "rounded", properties: [
                StylePropertyValue(name: "cornerRadius", value: 5)
                ])
            ])

        Stylist.shared.addTheme(secondTheme, name: "theme")

        XCTAssertEqual(view.backgroundColor, .red)
        XCTAssertEqual(view.layer.cornerRadius, 5)
    }

    func testSetClassStyles() throws {
        let theme = Theme(styles: [
            try Style(selector: "UIButton.blueBack", properties: [
                StylePropertyValue(name: "backgroundColor", value: "blue")
                ]),
            try Style(selector: "UIButton", properties: [
                StylePropertyValue(name: "cornerRadius", value: 10)
                ]),
            try Style(selector: "UIView", properties: [
                StylePropertyValue(name: "alpha", value: 0.5)
                ]),
            try Style(selector: NSStringFromClass(CustomView.self), properties: [
                StylePropertyValue(name: "backgroundColor", value: "green")
                ]),
            try Style(selector: "\(NSStringFromClass(CustomView.self)).blueBack", properties: [
                StylePropertyValue(name: "backgroundColor", value: "blue")
                ]),
            ])
        let container = UIView()
        let button = UIButton()
        let view = UIView()
        let customView = CustomView()

        Stylist.shared.addTheme(theme, name: "theme")

        container.addSubview(button)
        container.addSubview(view)
        container.addSubview(customView)

        XCTAssertEqual(view.layer.cornerRadius, 0)
        XCTAssertEqual(button.layer.cornerRadius, 10)
        XCTAssertEqual(button.backgroundColor, nil)
        XCTAssertEqual(customView.backgroundColor, .green)
        XCTAssertEqual(button.alpha, 0.5)
        XCTAssertEqual(view.alpha, 0.5)
        XCTAssertEqual(customView.alpha, 0.5)

        button.style = "blueBack"
        view.style = "blueBack"
        customView.style = "blueBack"

        XCTAssertEqual(button.backgroundColor, .blue)
        XCTAssertEqual(view.backgroundColor, nil)
        XCTAssertEqual(customView.backgroundColor, .blue)
    }

    func testAddingCustomProperties() throws {

        let property = StyleProperty(name: "property") { (view: CustomView, value: PropertyValue<String>) in
            view.customProperty = value.value
        }

        Stylist.shared.addProperty(property)
        let customView = CustomView()
        let style = try Style(selector: "custom", properties: [StylePropertyValue(name: "property", value: "hello")])
        Stylist.shared.apply(styleable: customView, style: style)

        XCTAssertEqual(customView.customProperty, "hello")
    }

    //TODO: test loading files

    //TODO: test watching files

    //TODO: test shared styles

    //TODO: test custom Styleable

    //TODO: test UIBarItem

}

class CustomView: UIView {

    var customProperty: String = ""
}

class TraitViewController: UIViewController {

    let childViewController: UIViewController
    let traits: [UITraitCollection]

    init(traits: [UITraitCollection], view: UIView) {
        self.traits = traits
        childViewController = UIViewController()
        super.init(nibName: nil, bundle: nil)

        self.view.addSubview(childViewController.view)
        addChildViewController(childViewController)
        childViewController.willMove(toParentViewController: self)
        childViewController.didMove(toParentViewController: self)
        childViewController.view.addSubview(view)
    }

    static func addTraits(_ traits: [UITraitCollection], to view: UIView) {
        _ = TraitViewController(traits: traits, view: view)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func overrideTraitCollection(forChildViewController childViewController: UIViewController) -> UITraitCollection? {
        return UITraitCollection(traitsFrom: traits)
    }
}

