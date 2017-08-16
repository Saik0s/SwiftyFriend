import XCTest
@testable import Generator

class TemplateInfoTests: XCTestCase {

    override func setUp() {

        super.setUp()
    }

    override func tearDown() {

        super.tearDown()
    }

    // MARK: - init

    func test_init_withCorrectArguments_shouldSuccess() {

        XCTAssertNoThrow(
                try TemplateInfo(
                        moduleName: "Module",
                        templateName: "Template",
                        destinationPath: "Classes",
                        destinationGroup: "Module",
                        isFolderRequired: true
                )
        )
    }

    func test_init_withEmptyModuleName_shouldFail() {

        XCTAssertThrowsError(
                try TemplateInfo(
                        moduleName: "",
                        templateName: "Template",
                        destinationPath: "Classes",
                        destinationGroup: "Module",
                        isFolderRequired: true
                )
        )
    }

    func test_init_withEmptyTemplateName_shouldFail() {

        XCTAssertThrowsError(
                try TemplateInfo(
                        moduleName: "Module",
                        templateName: "",
                        destinationPath: "Classes",
                        destinationGroup: "Module",
                        isFolderRequired: true
                )
        )
    }

    func test_init_withEmptyDestinationName_shouldFail() {

        XCTAssertThrowsError(
                try TemplateInfo(
                        moduleName: "Module",
                        templateName: "Template",
                        destinationPath: "",
                        destinationGroup: "Module",
                        isFolderRequired: true
                )
        )
    }

    func test_init_withoutDestinationGroup_shouldSuccess() {

        XCTAssertNoThrow(
                try TemplateInfo(
                        moduleName: "Module",
                        templateName: "Template",
                        destinationPath: "Classes",
                        isFolderRequired: true
                )
        )
    }

}
