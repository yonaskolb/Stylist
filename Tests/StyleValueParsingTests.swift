//
//  StyleValueParsingTests.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/5/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import XCTest
@testable import Stylist
import XCTest
import Yams

class StyleValueParsingTests: XCTestCase {

    func assertStyleValueParsing<T>(_ expected: T?, _ value: Any, file: StaticString = #file, line: UInt = #line) where T: Equatable, T: StyleValue, T.ParsedType == T {
        XCTAssertEqual(expected, T.parse(value: value), file: file, line: line)
    }

    func assertStyleValueParsingNil<T>(_ type: T.Type, _ value: Any, file: StaticString = #file, line: UInt = #line) where T: Equatable, T: StyleValue, T.ParsedType == T {
        XCTAssertNil(T.parse(value: value), file: file, line: line)
    }

    func testColorParsing() throws {
        assertStyleValueParsing(UIColor.red, "red")
        assertStyleValueParsing(UIColor.darkGray, "darkGray")
        assertStyleValueParsing(UIColor.darkGray, "dark gray")
        assertStyleValueParsing(UIColor(hexString: "333"), "333")
        assertStyleValueParsing(UIColor(hexString: "333"), "#333")
        assertStyleValueParsing(UIColor(hexString: "112233"), "112233")
        assertStyleValueParsing(UIColor(hexString: "112233"), "#112233")
        assertStyleValueParsing(UIColor(hexString: "112233")?.withAlphaComponent(0), "#11223300")
        assertStyleValueParsing(UIColor(hexString: "112233")?.withAlphaComponent(0), "11223300")
        assertStyleValueParsing(UIColor.red.withAlphaComponent(0.5), "red:0.5")
    }

    func testFontParsing() throws {
        assertStyleValueParsing(UIFont(name: "Arial", size: 12), "Arial:12")
        assertStyleValueParsing(UIFont.systemFont(ofSize: 20), 20)
        assertStyleValueParsing(UIFont.systemFont(ofSize: 20), "20")
        assertStyleValueParsing(UIFont.systemFont(ofSize: 20.5), "20.5")
        assertStyleValueParsing(UIFont.systemFont(ofSize: 20.5), 20.5)
        assertStyleValueParsing(UIFont.systemFont(ofSize: 20), "system:20")
        assertStyleValueParsing(UIFont.systemFont(ofSize: 20.5), "system:20.5")
        assertStyleValueParsing(UIFont.boldSystemFont(ofSize: 20), "systemBold:20")
        assertStyleValueParsing(UIFont.italicSystemFont(ofSize: 20), "systemItalic:20")
        assertStyleValueParsing(UIFont.systemFont(ofSize: 20, weight: .black), "systemBlack:20")
        assertStyleValueParsing(UIFont.systemFont(ofSize: 20, weight: .heavy), "systemHeavy:20")
        assertStyleValueParsing(UIFont.systemFont(ofSize: 20, weight: .light), "systemLight:20")
        assertStyleValueParsing(UIFont.systemFont(ofSize: 20, weight: .medium), "systemMedium:20")
        assertStyleValueParsing(UIFont.systemFont(ofSize: 20, weight: .semibold), "systemSemibold:20")
        assertStyleValueParsing(UIFont.systemFont(ofSize: 20, weight: .thin), "systemThin:20")
        assertStyleValueParsing(UIFont.systemFont(ofSize: 20, weight: .ultraLight), "systemUltraLight:20")
        assertStyleValueParsing(UIFont.systemFont(ofSize: 20, weight: .ultraLight), "systemultralight:20")
        assertStyleValueParsing(UIFont.preferredFont(forTextStyle: .title1), "title1")
        assertStyleValueParsing(UIFont(name: "Arial", size: UIFont.preferredFont(forTextStyle: .title1).pointSize), "Arial:title1")

        assertStyleValueParsingNil(UIFont.self, "invalid")
        assertStyleValueParsingNil(UIFont.self, "invalid:20")
        assertStyleValueParsingNil(UIFont.self, "Arial:nil")
        assertStyleValueParsingNil(UIFont.self, "systemInvalid:nil")
        assertStyleValueParsingNil(UIFont.self, "systemInvalid")
    }

    func testNumberParsing() throws {
        assertStyleValueParsing(1, 1)
        assertStyleValueParsing(1.0, 1.0)
        assertStyleValueParsing(2.1, 2.1)
        assertStyleValueParsing(2.1, "2.1")
        assertStyleValueParsing(2.1 as CGFloat, "2.1")
        assertStyleValueParsing(2.1 as CGFloat, 2.1)
        assertStyleValueParsing(2.1 as Float, "2.1")
        assertStyleValueParsing(2.1 as Float, 2.1)
        assertStyleValueParsing(2.1 as Double, "2.1")
        assertStyleValueParsing(2.1 as Double, 2.1)

        assertStyleValueParsingNil(Int.self, "invalid")
        assertStyleValueParsingNil(Double.self, "invalid")
        assertStyleValueParsingNil(Double.self,"")
    }

    func testBooleanParsing() throws {
        assertStyleValueParsing(true, true)
        assertStyleValueParsing(false, false)
        assertStyleValueParsing(true, "yes")
        assertStyleValueParsing(true, "true")
        assertStyleValueParsing(false, "no")
        assertStyleValueParsing(false, "false")
        assertStyleValueParsingNil(Bool.self, "")
        assertStyleValueParsingNil(Bool.self, "y")
        assertStyleValueParsingNil(Bool.self, "n")
    }

    func testContentModeParsing() throws {
        assertStyleValueParsing(UIViewContentMode.bottom, "bottom")
        assertStyleValueParsing(UIViewContentMode.bottomLeft, "bottomLeft")
        assertStyleValueParsing(UIViewContentMode.bottomRight, "bottomRight")
        assertStyleValueParsing(UIViewContentMode.center, "center")
        assertStyleValueParsing(UIViewContentMode.left, "left")
        assertStyleValueParsing(UIViewContentMode.redraw, "redraw")
        assertStyleValueParsing(UIViewContentMode.right, "right")
        assertStyleValueParsing(UIViewContentMode.scaleAspectFill, "scaleAspectFill")
        assertStyleValueParsing(UIViewContentMode.scaleAspectFit, "scaleAspectFit")
        assertStyleValueParsing(UIViewContentMode.scaleToFill, "scaleToFill")
        assertStyleValueParsing(UIViewContentMode.top, "top")
        assertStyleValueParsing(UIViewContentMode.topLeft, "topLeft")
        assertStyleValueParsing(UIViewContentMode.topRight, "topRight")

        assertStyleValueParsing(UIViewContentMode.topRight, "topright")
        assertStyleValueParsing(UIViewContentMode.topRight, "top right")

        assertStyleValueParsingNil(UILayoutConstraintAxis.self, "invalid")
    }

    func testUIStackViewAlignmentParsing() throws {
        assertStyleValueParsing(UIStackViewAlignment.fill, "fill")
        assertStyleValueParsing(UIStackViewAlignment.leading, "leading")
        assertStyleValueParsing(UIStackViewAlignment.top, "top")
        assertStyleValueParsing(UIStackViewAlignment.firstBaseline, "firstBaseline")
        assertStyleValueParsing(UIStackViewAlignment.center, "center")
        assertStyleValueParsing(UIStackViewAlignment.trailing, "trailing")
        assertStyleValueParsing(UIStackViewAlignment.bottom, "bottom")
        assertStyleValueParsing(UIStackViewAlignment.lastBaseline, "lastBaseline")

        assertStyleValueParsing(UIStackViewAlignment.lastBaseline, "lastbaseline")
        assertStyleValueParsing(UIStackViewAlignment.lastBaseline, "last baseline")

        assertStyleValueParsingNil(UILayoutConstraintAxis.self, "invalid")
    }

    func testUIStackViewDistributionParsing() throws {
        assertStyleValueParsing(UIStackViewDistribution.fill, "fill")
        assertStyleValueParsing(UIStackViewDistribution.fillEqually, "fillEqually")
        assertStyleValueParsing(UIStackViewDistribution.fillProportionally, "fillProportionally")
        assertStyleValueParsing(UIStackViewDistribution.equalSpacing, "equalSpacing")
        assertStyleValueParsing(UIStackViewDistribution.equalCentering, "equalCentering")

        assertStyleValueParsing(UIStackViewDistribution.equalCentering, "equalcentering")
        assertStyleValueParsing(UIStackViewDistribution.equalCentering, "equal centering")

        assertStyleValueParsingNil(UILayoutConstraintAxis.self, "invalid")
    }

    func testUILayoutConstraintAxisParsing() throws {
        assertStyleValueParsing(UILayoutConstraintAxis.vertical, "vertical")
        assertStyleValueParsing(UILayoutConstraintAxis.horizontal, "horizontal")

        assertStyleValueParsingNil(UILayoutConstraintAxis.self, "invalid")
    }

    func testCGSizeParsing() throws {
        assertStyleValueParsing(CGSize(width: 1, height: 2), "1,2")
        assertStyleValueParsing(CGSize(width: 1, height: 2), "1, 2")
        assertStyleValueParsing(CGSize(width: 1.1, height: 2.2), "1.1,2.2")
        assertStyleValueParsing(CGSize(width: 1, height: 1), "1")
        assertStyleValueParsing(CGSize(width: 1, height: 1), 1)

        assertStyleValueParsingNil(CGSize.self, "1,2,3")
        assertStyleValueParsingNil(CGSize.self, "invalid")
    }

    func testUIEdgeInsetsParsing() throws {
        assertStyleValueParsing(UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4), "1,2,3,4")
        assertStyleValueParsing(UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4), "1, 2, 3, 4")
        assertStyleValueParsing(UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1), "1,2")
        assertStyleValueParsing(UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), "1")
        assertStyleValueParsing(UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), 1)
        assertStyleValueParsing(UIEdgeInsets(top: 1.1, left: 2.1, bottom: 3.1, right: 4.1), "1.1,2.1,3.1,4.1")
        assertStyleValueParsing(UIEdgeInsets(top: 2.1, left: 1.1, bottom: 2.1, right: 1.1), "1.1,2.1")
        assertStyleValueParsing(UIEdgeInsets(top: 1.1, left: 1.1, bottom: 1.1, right: 1.1), "1.1")
        assertStyleValueParsing(UIEdgeInsets(top: 1.1, left: 1.1, bottom: 1.1, right: 1.1), 1.1)

        assertStyleValueParsingNil(UIEdgeInsets.self, "1,2,3")
        assertStyleValueParsingNil(UIEdgeInsets.self, "1,2,3,4,5")
        assertStyleValueParsingNil(UIEdgeInsets.self, "invalid")
    }

    func testLayoutAnchorParsing() throws {
        assertStyleValueParsing(LayoutAnchor(constant: 10.0), "10.0")
        assertStyleValueParsing(LayoutAnchor(constant: 10), "10")
        assertStyleValueParsing(LayoutAnchor(constant: 10), 10)
        assertStyleValueParsing(LayoutAnchor(constant: 10.0, equality: .greaterThanOrEqual), ">=10")
        assertStyleValueParsing(LayoutAnchor(constant: 10.0, equality: .lessThanOrEqual), "<=10")
        assertStyleValueParsing(LayoutAnchor(constant: 10.0, equality: .equal), "==10")

        assertStyleValueParsingNil(LayoutAnchor.self, "=>10")
        assertStyleValueParsingNil(LayoutAnchor.self, "10>=")
    }

    func testAspectRatioAnchorParsing() throws {
        assertStyleValueParsing(AspectRatioAnchor(ratio: 1), "1")
        assertStyleValueParsing(AspectRatioAnchor(ratio: 1), 1)
        assertStyleValueParsing(AspectRatioAnchor(ratio: 0.5), "0.5")
        assertStyleValueParsing(AspectRatioAnchor(ratio: 0.5), "1/2")
        assertStyleValueParsing(AspectRatioAnchor(ratio: 16/9), "16/9")

        assertStyleValueParsingNil(AspectRatioAnchor.self, "invalid")
    }

    #if os(iOS)
    func testUIBarStyleParsing() throws {
        assertStyleValueParsing(UIBarStyle.black, "black")
        assertStyleValueParsing(UIBarStyle.default, "default")
        assertStyleValueParsing(UIBarStyle.blackTranslucent, "blackTranslucent")

        assertStyleValueParsing(UIBarStyle.blackTranslucent, "black translucent")
        assertStyleValueParsing(UIBarStyle.blackTranslucent, "blacktranslucent")

        assertStyleValueParsingNil(UIViewContentMode.self, "invalid")
    }
    #endif
}
