//
// XCTAssertExtensions.swift
// SwiftyFriend
//
// Created by Igor Tarasenko
//

import Foundation
import XCTest
import PathKit

public func XCTAssertFileExist(_ expression: @autoclosure () throws -> Path,
                               _ message: @autoclosure () -> String = "",
                               file: StaticString = #file,
                               line: UInt = #line) {

    XCTAssertTrue(try expression().exists, message, file: file, line: line)
}
