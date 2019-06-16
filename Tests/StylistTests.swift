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

    // to get around cross platform tests
    fileprivate let customViewClassName = NSStringFromClass(CustomView.self)
    fileprivate let customViewControllerClassName = NSStringFromClass(CustomViewController.self)

    override func setUp() {
        super.setUp()
        Stylist.shared.clear()
    }

    func testApplyStyle() throws {
        let stylist = Stylist()

        let style = try Style(properties: [
            StylePropertyValue(name: "backgroundColor", value: "blue"),
        ])

        let view = UIView()
        stylist.apply(style: style, to: view)
        XCTAssertEqual(view.backgroundColor, .blue)
    }

    func testSetStylesWithCustomStylist() throws {
        let stylist = Stylist()

        let theme = try Theme(string: """
        styles:
            blueBack:
                backgroundColor: blue
            rounded:
                cornerRadius: 10
        """)

        stylist.addTheme(theme, name: "theme")
        XCTAssertEqual(stylist.themes["theme"], theme)

        let view = UIView()
        view.styles = ["blueBack", "rounded"]
        stylist.style(view)

        XCTAssertEqual(view.backgroundColor, .blue)
        XCTAssertEqual(view.layer.cornerRadius, 10)

        let secondTheme = try Theme(string: """
        styles:
            blueBack:
                backgroundColor: red
            rounded:
                cornerRadius: 5
        """)

        stylist.addTheme(secondTheme, name: "theme")

        XCTAssertEqual(view.backgroundColor, .red)
        XCTAssertEqual(view.layer.cornerRadius, 5)
    }

    func testParentStyles() throws {

        let theme = try Theme(string: """
        styles:
            custom:
                backgroundColor: blue
                parent:
                    cornerRadius: 10
                viewController:
                    view:
                        tintColor: red
                    navigationBar:
                        tintColor: orange
        """)

        let viewController = UIViewController()
        let navigationViewController = UINavigationController(rootViewController: viewController)
        let view = UIView()
        let superview = UIView()
        superview.addSubview(view)
        viewController.view.addSubview(superview)

        view.style = "custom"
        Stylist.shared.apply(theme: theme)

        XCTAssertEqual(view.backgroundColor, .blue)
        XCTAssertEqual(superview.backgroundColor, nil)
        XCTAssertEqual(superview.layer.cornerRadius, 10)
        XCTAssertEqual(view.layer.cornerRadius, 0)
        XCTAssertEqual(viewController.view.tintColor, .red)
        XCTAssertEqual(viewController.navigationController?.navigationBar.tintColor, .orange)
        XCTAssertEqual(navigationViewController.navigationBar.tintColor, .orange)
    }

    func testSettingStyles() {
        let view = UIView()

        view.style = "test"
        XCTAssertEqual(view.style, "test")
        XCTAssertEqual(view.styles, ["test"])

        view.styles = ["one", "two"]
        XCTAssertEqual(view.styles, ["one", "two"])
        XCTAssertEqual(view.style, "one,two")

        view.styles = []
        XCTAssertEqual(view.style, nil)
        XCTAssertEqual(view.styles, [])

        view.style = "test, one,two"
        XCTAssertEqual(view.style, "test,one,two")
        XCTAssertEqual(view.styles, ["test", "one", "two"])
    }

    func testFilteringSizeClasses() throws {

        let view = UIView()
        let traitCollection = UITraitCollection(horizontalSizeClass: .compact)
        TraitViewController.addTraits([traitCollection], to: view)

        let style = try Style(properties: [
            StylePropertyValue(name: "backgroundColor", value: "green", context: PropertyContext(styleContext: .init(horizontalSizeClass: .compact))),
            StylePropertyValue(name: "backgroundColor", value: "red", context: PropertyContext(styleContext: .init(horizontalSizeClass: .regular))),
        ])
        Stylist.shared.apply(style: style, to: view)

        XCTAssertEqual(view.backgroundColor, .green)
    }

    func testSetStyles() throws {
        
        let theme = try Theme(string: """
        styles:
            blueBack:
                backgroundColor: blue
            rounded:
                cornerRadius: 10
        """)

        Stylist.shared.addTheme(theme, name: "theme")
        let view = UIView()
        view.styles = ["blueBack", "rounded"]

        XCTAssertEqual(view.backgroundColor, .blue)
        XCTAssertEqual(view.layer.cornerRadius, 10)

        let secondTheme = Theme(styles: [
            try StyleSelector(selector: "blueBack", style: Style(properties: [
                StylePropertyValue(name: "backgroundColor", value: "red"),
            ])),
            try StyleSelector(selector: "rounded", style: Style(properties: [
                StylePropertyValue(name: "cornerRadius", value: 5),
            ])),
        ])

        Stylist.shared.addTheme(secondTheme, name: "theme")

        XCTAssertEqual(view.backgroundColor, .red)
        XCTAssertEqual(view.layer.cornerRadius, 5)
    }

    func testSetClassStyles() throws {

        let theme = try Theme(string: """
        styles:
            UIButton.blueBack:
                backgroundColor: blue
            UIButton:
                cornerRadius: 10
            UIView:
                alpha: 0.5
            \(customViewClassName):
                backgroundColor: green
            \(customViewClassName).blueBack:
                backgroundColor: blue
        """)

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

    func testStyleSelectorFiltering() throws {

        func styleable(_ styleable: Styleable, has selector: String) -> Bool {
            let style = try! StyleSelector(selector: selector, style: Style(properties: []))
            return style.applies(to: styleable)
        }

        let viewController = CustomViewController()
        viewController.style = "controller"
        let navigationViewController = UINavigationController(rootViewController: viewController)

        let container = UIStackView()
        container.style = "container"
        let child = UIView()
        child.style = "child"
        let customView = CustomView()
        customView.style = "custom"
        container.addSubview(customView)
        customView.addSubview(child)
        viewController.view.addSubview(container)

        // confirm view hierachy
        XCTAssertEqual(child.superview, customView)
        XCTAssertEqual(child.next, customView)

        XCTAssertEqual(customView.superview, container)
        XCTAssertEqual(customView.next, container)

        XCTAssertEqual(container.superview, viewController.view)
        XCTAssertEqual(container.next, viewController.view)

        XCTAssertEqual(viewController.view.superview, nil)
        XCTAssertEqual(viewController.view.next, viewController)

        XCTAssertEqual(viewController.parent, navigationViewController)
        XCTAssertEqual(viewController.next, nil)


        // confirm postives matches
        XCTAssertEqual(styleable(child, has: "container child"), true)
        XCTAssertEqual(styleable(child, has: "container custom child"), true)
        XCTAssertEqual(styleable(child, has: "UIStackView.container custom child"), true)
        XCTAssertEqual(styleable(child, has: "container UIView.custom child"), true)
        XCTAssertEqual(styleable(child, has: "container \(customViewClassName).custom child"), true)
        XCTAssertEqual(styleable(child, has: "container \(customViewClassName) child"), true)
        XCTAssertEqual(styleable(child, has: "UIStackView \(customViewClassName).custom UIView.child"), true)
        XCTAssertEqual(styleable(child, has: "UIStackView child"), true)
        XCTAssertEqual(styleable(child, has: "\(customViewClassName).custom child"), true)
        XCTAssertEqual(styleable(child, has: "\(customViewClassName) child"), true)

        XCTAssertEqual(styleable(child, has: "UINavigationController child"), true)
        XCTAssertEqual(styleable(child, has: "UIViewController child"), true)
        XCTAssertEqual(styleable(child, has: "UIViewController.controller child"), true)
        XCTAssertEqual(styleable(child, has: "UINavigationController \(customViewControllerClassName) container child"), true)
        XCTAssertEqual(styleable(child, has: "UINavigationController .controller child"), true)
        XCTAssertEqual(styleable(child, has: "\(customViewControllerClassName).controller child"), true)

        XCTAssertEqual(styleable(navigationViewController, has: "UINavigationController"), true)
        XCTAssertEqual(styleable(viewController, has: "\(customViewControllerClassName)"), true)
        XCTAssertEqual(styleable(viewController, has: "UINavigationController \(customViewControllerClassName)"), true)
        XCTAssertEqual(styleable(viewController, has: "UINavigationController \(customViewControllerClassName).controller"), true)

        // confirm negative matches
        XCTAssertEqual(styleable(child, has: "invalid child"), false)
        XCTAssertEqual(styleable(child, has: "invalid custom child"), false)
        XCTAssertEqual(styleable(child, has: "UIButton.container custom child"), false)
        XCTAssertEqual(styleable(child, has: "container UIStackView.custom child"), false)
        XCTAssertEqual(styleable(child, has: "container \(customViewClassName).invalid child"), false)
        XCTAssertEqual(styleable(child, has: "invalid \(customViewClassName) child"), false)
        XCTAssertEqual(styleable(child, has: "UIStackView \(customViewClassName).custom UIView.invalid"), false)
        XCTAssertEqual(styleable(child, has: "\(customViewClassName).custom invalid"), false)
        XCTAssertEqual(styleable(child, has: "\(customViewClassName).invalid child"), false)
        XCTAssertEqual(styleable(child, has: "\(customViewControllerClassName).invalid child"), false)
        XCTAssertEqual(styleable(child, has: "UINavigationController UINavigationController child"), false)
    }

    func testAddingCustomProperties() throws {

        let property = StyleProperty(name: "property") { (view: CustomView, value: PropertyValue<String>) in
            view.customProperty = value.value
        }

        Stylist.shared.addProperty(property)
        let customView = CustomView()
        let style = try Style(properties: [StylePropertyValue(name: "property", value: "hello")])
        Stylist.shared.apply(style: style, to: customView)

        XCTAssertEqual(customView.customProperty, "hello")
    }

    func testStyleSpecificity() throws {

        let theme = try Theme(string: """
        styles:
            UIButton.primary:
                backgroundColor: blue
            primary:
                backgroundColor: red
        """)

        let view = UIButton()
        view.style = "primary"
        Stylist.shared.apply(theme: theme)

        XCTAssertEqual(view.backgroundColor, .blue)
    }

    // TODO: test loading files

    // TODO: test watching files

    // TODO: test custom Styleable

    // TODO: test UIBarItem

}

class CustomView: UIView {

    var customProperty: String = ""
}

class CustomViewController: UIViewController {

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
        addChild(childViewController)
        childViewController.willMove(toParent: self)
        childViewController.didMove(toParent: self)
        childViewController.view.addSubview(view)
    }

    static func addTraits(_ traits: [UITraitCollection], to view: UIView) {
        _ = TraitViewController(traits: traits, view: view)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func overrideTraitCollection(forChild childViewController: UIViewController) -> UITraitCollection? {
        return UITraitCollection(traitsFrom: traits)
    }
}
