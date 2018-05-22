//
//  ViewPropertyTests.swift
//  Stylist
//
//  Created by Yonas Kolb on 22/5/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation
import XCTest
@testable import Stylist

class ViewPropertiesTests: XCTestCase {

    func testViewProperty<T: Equatable>(property: String, value: Any, file: StaticString = #file, line: UInt = #line, _ keyPath: WritableKeyPath<UIView, T>, expectedValue: T) {
        testProperty(UIView(), property: property, value: value, file: file, line: line) { view in
            view[keyPath: keyPath] == expectedValue
        }
    }

    func testViewProperty(property: String, value: Any, file: StaticString = #file, line: UInt = #line, _ compare: (UIView) -> Bool) {
        testProperty(UIView(), property: property, value: value, file: file, line: line, compare)
    }

    func testProperty<T>(_ styleable: T, property: String, value: Any, file: StaticString = #file, line: UInt = #line, _ compare: (T) -> Bool) {
        do {
            let style = try Style(name: "style", properties: [
                StylePropertyValue(string: property, value: value)
                ])
            Stylist.shared.apply(styleable: styleable, style: style)
            if !compare(styleable) {
                XCTFail("Did not set property \(property) using \(value)", file: file, line: line)
            }
        } catch {
            XCTFail("Setting property \(property) using \(value) failed with \n\(error)")
        }
    }

    func testViewProperties() {

        testViewProperty(property: "backgroundColor", value: "red") {
            $0.backgroundColor == .red
        }

        testViewProperty(property: "tintColor", value: "red") {
            $0.tintColor == .red
        }

        testViewProperty(property: "alpha", value: "0.5") {
            $0.alpha == 0.5
        }

        testViewProperty(property: "clipsToBounds", value: "true") {
            $0.clipsToBounds == true
        }

        testViewProperty(property: "contentMode", value: "bottomLeft") {
            $0.contentMode == .bottomLeft
        }

        testViewProperty(property: "contentMode", value: "scale aspect fit") {
            $0.contentMode == .scaleAspectFit
        }

        testViewProperty(property: "visible", value: "false") {
            $0.isHidden == true
        }

        testViewProperty(property: "hidden", value: "true") {
            $0.isHidden == true
        }

        testViewProperty(property: "layoutMargins", value: "10,20") {
            $0.layoutMargins == UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        }
    }

    func testViewFrames() {

        testViewProperty(property: "position", value: "10,12") {
            $0.frame.origin == CGPoint(x: 10, y: 12) &&
                $0.frame.size == .zero
        }

        testViewProperty(property: "origin", value: "10,12") {
            $0.frame.origin == CGPoint(x: 10, y: 12) &&
                $0.frame.size == .zero
        }

        testViewProperty(property: "size", value: "10,12") {
            $0.frame.size == CGSize(width: 10, height: 12)
        }

        testViewProperty(property: "frame", value: "10,12,13,14") {
            $0.frame == CGRect(origin: CGPoint(x: 10, y: 12), size:  CGSize(width: 13, height: 14))
        }
    }

    func testLayerProperties() {

        testViewProperty(property: "borderColor", value: "red") {
            $0.layer.borderColor == UIColor.red.cgColor
        }

        testViewProperty(property: "borderWidth", value: 2.5) {
            $0.layer.borderWidth == 2.5
        }

        testViewProperty(property: "cornerRadius", value: 2.5) {
            $0.layer.cornerRadius == 2.5
        }

        testViewProperty(property: "shadowOpacity", value: "0.5") {
            $0.layer.shadowOpacity == 0.5
        }

        testViewProperty(property: "shadowColor", value: "red") {
            $0.layer.shadowColor == UIColor.red.cgColor
        }

        testViewProperty(property: "shadowOffset", value: "0.5, 2") {
            $0.layer.shadowOffset == CGSize(width: 0.5, height: 2)
        }

        testViewProperty(property: "shadowRadius", value: "3") {
            $0.layer.shadowRadius == 3
        }
    }

//    func testConstraintProperties() {
//
//        testViewProperty(property: "widthAnchor", value: "<=10") { view in
//            let hasConstraint = view.constraints.contains { constraint in
//                constraint.isActive == true &&
//                constraint.firstAttribute == .width &&
//                    constraint.constant == 10 &&
//                    constraint.relation == NSLayoutRelation.lessThanOrEqual
//            }
//            return hasConstraint && view.translatesAutoresizingMaskIntoConstraints == false
//        }
//
//        testViewProperty(property: "heightAnchor", value: ">=10") { view in
//            let hasConstraint = view.constraints.contains { constraint in
//                constraint.isActive == true &&
//                constraint.firstAttribute == .height &&
//                    constraint.constant == 10 &&
//                    constraint.relation == NSLayoutRelation.greaterThanOrEqual
//            }
//            return hasConstraint && view.translatesAutoresizingMaskIntoConstraints == false
//        }
//
//        testViewProperty(property: "widthAnchor", value: "10") { view in
//            let hasConstraint = view.constraints.contains { constraint in
//                constraint.isActive == true &&
//                constraint.firstAttribute == .width &&
//                    constraint.constant == 10 &&
//                    constraint.relation == NSLayoutRelation.equal
//            }
//            return hasConstraint && view.translatesAutoresizingMaskIntoConstraints == false
//        }
//
//        testViewProperty(property: "aspectRatioAnchor", value: "1/2") { view in
//            let hasConstraint = view.constraints.contains { constraint in
//                constraint.isActive == true &&
//                constraint.firstAttribute == .width &&
//                    constraint.secondAttribute == .height &&
//                    constraint.constant == 0 &&
//                    constraint.multiplier == 0.5 &&
//                    constraint.relation == NSLayoutRelation.equal
//            }
//            return hasConstraint && view.translatesAutoresizingMaskIntoConstraints == false
//        }
//    }

    func testButtonProperties() {

        testProperty(UIButton(), property: "imageEdgeInsets", value: "10") {
            $0.imageEdgeInsets == UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }

        testProperty(UIButton(), property: "titleEdgeInsets", value: "10") {
            $0.titleEdgeInsets == UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }

        testProperty(UIButton(), property: "contentEdgeInsets", value: "10") {
            $0.contentEdgeInsets == UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }

        testProperty(UIButton(), property: "textColor", value: "red") {
            $0.titleColor(for: .normal) == .red
        }

        testProperty(UIButton(), property: "textColor:highlighted", value: "red") {
            $0.titleColor(for: .normal) == UIButton().titleColor(for: .normal) &&
            $0.titleColor(for: .highlighted) == .red
        }

        testProperty(UIButton(), property: "titleColor:highlighted", value: "red") {
            $0.titleColor(for: .normal) == UIButton().titleColor(for: .normal) &&
                $0.titleColor(for: .highlighted) == .red
        }

        testProperty(UIButton(), property: "font", value: "Arial:20") {
            $0.titleLabel?.font == UIFont(name: "Arial", size: 20)
        }

        testProperty(UIButton(), property: "titleFont", value: "title2") {
            $0.titleLabel?.font == UIFont.preferredFont(forTextStyle: .title2)
        }
    }

    //TODO: test other default properties
}
