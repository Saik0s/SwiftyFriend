//
// GeneratorTestsHelpers.swift
// SwiftyFriend
//
// Created by Igor Tarasenko
//

import Foundation
import PathKit
import XCTest

internal enum Fixture {
    case root
    case project
    case correctTemplate
    case incorrectTemplate

    var path: Path {
        switch self {
            case .root:
                return Path(#file).parent() + "fixtures"
            case .project:
                return Fixture.root.path + "EmptyProject"
            case .correctTemplate:
                return Fixture.root.path + "correct.stencil"
            case .incorrectTemplate:
                return Fixture.root.path + "incorrect.stencil"
        }
    }
}

internal enum Constant: String {
    case templateName          = "Class"
    case templateFileName      = "class"
    case templateFileExtension = "stencil"
    case deepDestination       = "EmptyCLI/ChildFolder/DeepFolder"
    case projectName           = "EmptyProject"
    case targetName            = "EmptyCLI"
}

internal func createProjectCopy() throws -> Path {

    let projectPath = try Path.uniqueTemporary() + Constant.projectName.rawValue
    try Fixture.project.path.copy(projectPath)
    Path.current = projectPath
    return projectPath
}
