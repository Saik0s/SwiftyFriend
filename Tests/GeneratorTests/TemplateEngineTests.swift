//
// TemplateEngineTests.swift
// SwiftyFriend
//
// Created by Igor Tarasenko
//

import XCTest
import PathKit
@testable import Generator

class TemplateEngineTests: XCTestCase {

    var projectPath: Path!

    override func setUp() {

        super.setUp()
        XCTAssertNoThrow(projectPath = try createProjectCopy())
    }

    override func tearDown() {

        projectPath = nil
        super.tearDown()
    }

    // MARK: - generate

    func test_generate_withIncorrectInfo_shouldFail() {
        
        var info: TemplateInfo!
        do {
            info = try TemplateInfo(
                    moduleName: "NewModule",
                    templateName: "t",
                    destinationPath: "GeneratorInputs/EmptyProject/EmptyCLI/ChildFolder/DeepFolder",
                    destinationGroup: nil,
                    isFolderRequired: false
            )
        }
        catch {
            XCTFail("TemplateInfo init failed")
        }
        let engine: TemplateEngine = TemplateEngine(with: info)
        XCTAssertThrowsError(try engine.generate())
    }

    func test_generate_withCorrectInfo_shouldSuccess() {
        
        var info: TemplateInfo!
        do {
            info   = try TemplateInfo(
                moduleName: "NewModule",
                templateName: Constant.templateName.rawValue,
                destinationPath: Constant.deepDestination.rawValue,
                isFolderRequired: true
            )
        }
        catch {
            XCTFail("TemplateInfo init failed")
        }
        let engine: TemplateEngine = TemplateEngine(with: info)
        XCTAssertNoThrow(try engine.generate())
    }

    func test_generate_withCorrectInfo_shouldCreateFile() {

        let moduleName:        String = "NewModule"
        let templateName:      String = Constant.templateName.rawValue
        let destination:       String = Constant.deepDestination.rawValue
        let isFolderRequired:  Bool   = true
        let generatedFilePath: Path   = Path(destination) + Path(moduleName) + Path(
                Constant.templateFileName.rawValue + ".swift"
        )

        do {
            let info   = try TemplateInfo(
                    moduleName: moduleName,
                    templateName: templateName,
                    destinationPath: destination,
                    isFolderRequired: isFolderRequired
            )
            let engine = TemplateEngine(with: info)
            try engine.generate()
        }
        catch {
            XCTFail("generate failed")
        }

        XCTAssertFileExist(generatedFilePath)
    }

    func test_generate_withCorrectInfo_shouldCreateGroup() {

        // TODO
    }
}
