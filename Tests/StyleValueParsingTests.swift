//
//  StyleValueParsingTests.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/5/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import XCTest
@testable import Stylist
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
        assertStyleValueParsingNil(Double.self, "")
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
        assertStyleValueParsing(UIView.ContentMode.bottom, "bottom")
        assertStyleValueParsing(UIView.ContentMode.bottomLeft, "bottomLeft")
        assertStyleValueParsing(UIView.ContentMode.bottomRight, "bottomRight")
        assertStyleValueParsing(UIView.ContentMode.center, "center")
        assertStyleValueParsing(UIView.ContentMode.left, "left")
        assertStyleValueParsing(UIView.ContentMode.redraw, "redraw")
        assertStyleValueParsing(UIView.ContentMode.right, "right")
        assertStyleValueParsing(UIView.ContentMode.scaleAspectFill, "scaleAspectFill")
        assertStyleValueParsing(UIView.ContentMode.scaleAspectFit, "scaleAspectFit")
        assertStyleValueParsing(UIView.ContentMode.scaleToFill, "scaleToFill")
        assertStyleValueParsing(UIView.ContentMode.top, "top")
        assertStyleValueParsing(UIView.ContentMode.topLeft, "topLeft")
        assertStyleValueParsing(UIView.ContentMode.topRight, "topRight")

        assertStyleValueParsing(UIView.ContentMode.topRight, "topright")
        assertStyleValueParsing(UIView.ContentMode.topRight, "top right")

        assertStyleValueParsingNil(NSLayoutConstraint.Axis.self, "invalid")
    }

    func testUIStackViewAlignmentParsing() throws {
        assertStyleValueParsing(UIStackView.Alignment.fill, "fill")
        assertStyleValueParsing(UIStackView.Alignment.leading, "leading")
        assertStyleValueParsing(UIStackView.Alignment.top, "top")
        assertStyleValueParsing(UIStackView.Alignment.firstBaseline, "firstBaseline")
        assertStyleValueParsing(UIStackView.Alignment.center, "center")
        assertStyleValueParsing(UIStackView.Alignment.trailing, "trailing")
        assertStyleValueParsing(UIStackView.Alignment.bottom, "bottom")
        assertStyleValueParsing(UIStackView.Alignment.lastBaseline, "lastBaseline")

        assertStyleValueParsing(UIStackView.Alignment.lastBaseline, "lastbaseline")
        assertStyleValueParsing(UIStackView.Alignment.lastBaseline, "last baseline")

        assertStyleValueParsingNil(NSLayoutConstraint.Axis.self, "invalid")
    }

    func testUIStackViewDistributionParsing() throws {
        assertStyleValueParsing(UIStackView.Distribution.fill, "fill")
        assertStyleValueParsing(UIStackView.Distribution.fillEqually, "fillEqually")
        assertStyleValueParsing(UIStackView.Distribution.fillProportionally, "fillProportionally")
        assertStyleValueParsing(UIStackView.Distribution.equalSpacing, "equalSpacing")
        assertStyleValueParsing(UIStackView.Distribution.equalCentering, "equalCentering")

        assertStyleValueParsing(UIStackView.Distribution.equalCentering, "equalcentering")
        assertStyleValueParsing(UIStackView.Distribution.equalCentering, "equal centering")

        assertStyleValueParsingNil(NSLayoutConstraint.Axis.self, "invalid")
    }

    func testUILayoutConstraintAxisParsing() throws {
        assertStyleValueParsing(NSLayoutConstraint.Axis.vertical, "vertical")
        assertStyleValueParsing(NSLayoutConstraint.Axis.horizontal, "horizontal")

        assertStyleValueParsingNil(NSLayoutConstraint.Axis.self, "invalid")
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
        assertStyleValueParsing(LayoutAnchor(constant: 10.0, equality: .equal), "10")

        assertStyleValueParsingNil(LayoutAnchor.self, "=>10")
        assertStyleValueParsingNil(LayoutAnchor.self, "10>=")
    }

    func testAspectRatioAnchorParsing() throws {
        assertStyleValueParsing(AspectRatioAnchor(ratio: 1), "1")
        assertStyleValueParsing(AspectRatioAnchor(ratio: 1), 1)
        assertStyleValueParsing(AspectRatioAnchor(ratio: 0.5), "0.5")
        assertStyleValueParsing(AspectRatioAnchor(ratio: 0.5), "1/2")
        assertStyleValueParsing(AspectRatioAnchor(ratio: 16 / 9), "16/9")

        assertStyleValueParsingNil(AspectRatioAnchor.self, "invalid")
    }

    #if os(iOS)
        func testUIBarStyleParsing() throws {
            assertStyleValueParsing(UIBarStyle.black, "black")
            assertStyleValueParsing(UIBarStyle.default, "default")
            assertStyleValueParsing(UIBarStyle.black, "blackTranslucent")

            assertStyleValueParsing(UIBarStyle.black, "black translucent")
            assertStyleValueParsing(UIBarStyle.black, "blacktranslucent")

            assertStyleValueParsingNil(UIView.ContentMode.self, "invalid")
        }
    #endif
}
