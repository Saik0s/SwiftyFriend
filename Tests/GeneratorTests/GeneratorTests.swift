//
// GeneratorTests.swift
// SwiftyFriend
//
// Created by Igor Tarasenko
//

import XCTest
import PathKit
@testable import Generator

class GeneratorTests: XCTestCase {

    var generator: Generator!
    var projectPath: Path!

    override func setUp() {

        super.setUp()
        XCTAssertNoThrow(projectPath = try createProjectCopy())
        generator = Generator()
    }

    override func tearDown() {

        generator = nil
        projectPath = nil
        super.tearDown()
    }

    // MARK: - execute

    func test_execute_withEmptyInput_shouldFail() {

        XCTAssertThrowsError(try generator.execute(with: []))
    }

    // MARK: - run

    func test_run_withTemplateNameModuleNameDestinationPath_shouldSuccess() {

        let arguments: [String] = [Constant.templateName.rawValue, "NewModule", Constant.deepDestination.rawValue]
        XCTAssertNoThrow(try generator.run(arguments))
    }
}

