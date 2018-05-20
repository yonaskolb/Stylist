//
//  TestHelpers.swift
//  Stylist
//
//  Created by Yonas Kolb on 20/5/18.
//  Copyright © 2018 Stylist. All rights reserved.
//

import Foundation
import XCTest

func expectError<T: Error>(_ expectedError: T, file: StaticString = #file, line: UInt = #line, _ closure: () throws -> Void) where T: Equatable {
    do {
        try closure()
        XCTFail("Supposed to fail with error \(expectedError)", file: file, line: line)
    } catch let error as T {
        XCTAssertEqual(error, expectedError, file: file, line: line)
    } catch {
        XCTFail("Failed with \(error) but expected error \(expectedError)", file: file, line: line)
    }
}
