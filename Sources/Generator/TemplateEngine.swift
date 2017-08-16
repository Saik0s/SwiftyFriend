//
// TemplateEngine.swift
// SwiftyFriend
//
// Created by Igor Tarasenko
//

import Foundation
import Base
import Stencil
import PathKit
import xcodeproj

public protocol TemplateInfoType {
    var moduleName: String { get }
    var templateName: String { get }
    var destinationPath: String { get }
    var destinationGroup: String { get }
    var isFolderRequired: Bool { get }
}

public protocol TemplateEngineType {
    var info: TemplateInfoType { get }

    init(with info: TemplateInfoType)
    func generate(with completion: CompletionHandler?) throws
}

public struct TemplateInfo: TemplateInfoType {
    public let moduleName: String
    public let templateName: String
    public let destinationPath: String
    public let destinationGroup: String
    public let isFolderRequired: Bool

    public init(
        moduleName: String,
        templateName: String,
        destinationPath: String,
        destinationGroup: String? = nil,
        isFolderRequired: Bool
    ) throws {

        do {
            self.moduleName = try moduleName.throwOnEmpty()
            self.templateName = try templateName.throwOnEmpty()
            self.destinationPath = try destinationPath.throwOnEmpty()
            self.destinationGroup = destinationGroup ?? ""
            self.isFolderRequired = isFolderRequired
        } catch {
            throw Generator.Error.wrongArguments
        }
    }
}

internal final class TemplateEngine: TemplateEngineType {
    private var templateFolderPath: Path?
    private var destinationFolderPath: Path?
    private var projectPath: Path?
    private var project: XcodeProj?
    private var isNewGroup: Bool = false
    private var destinationGroup: PBXGroup?
    private var templateFilePaths: [Path] = []

    internal let info: TemplateInfoType

    internal init(with info: TemplateInfoType) {

        self.info = info
    }

    internal func generate(with completion: CompletionHandler? = nil) throws {

        try checkTemplatePath()
        try checkDestinationPath()
        try checkProjectFile()
        try createFolderIfNeed()
        try createModuleGroupIfNeed()

        guard var destinationGroup = destinationGroup,
            let destinationFolderPath = destinationFolderPath,
            let templateFolderPath = templateFolderPath,
            var project = project,
            let projectPath = projectPath else {
            throw Generator.Error.wrongArguments
        }

        templateFilePaths = templateFolderPath.glob("*.stencil")
        let templateNames: [String] = templateFilePaths.flatMap { path in
            path.lastComponent
        }

        let fsLoader = FileSystemLoader(paths: [templateFolderPath])
        let environment = Environment(loader: fsLoader)

        for name in templateNames {
            let resultFile = destinationFolderPath + Path(name).lastComponentWithoutExtension.appending(
                ".swift"
            )
            let context: [String: Any] = TemplateContext.basic(
                name: info.moduleName,
                file: resultFile.lastComponent
            ).context
            let rendered = try environment.renderTemplate(name: name, context: context)
            try resultFile.write(rendered)
            let fileRef = PBXFileReference(
                reference: project.pbxproj.generateUUID(for: PBXFileReference.self),
                sourceTree: .group,
                name: nil,
                fileEncoding: 4,
                explicitFileType: nil,
                lastKnownFileType: "swift",
                path: resultFile.lastComponent,
                includeInIndex: nil
            )
            let buildFile = PBXBuildFile(
                reference: project.pbxproj.generateUUID(for: PBXBuildFile.self),
                fileRef: fileRef.reference
            )
            destinationGroup.children.append(fileRef.reference)
            project.pbxproj.objects = project.pbxproj.objects.map { object in
                guard case var PBXObject.pbxSourcesBuildPhase(buildPhase) = object else {
                    return object
                }
                buildPhase.files.insert(buildFile.reference)
                return PBXObject.pbxSourcesBuildPhase(buildPhase)
            }
            project.pbxproj.objects.append(PBXObject.pbxFileReference(fileRef))
            project.pbxproj.objects.append(PBXObject.pbxBuildFile(buildFile))
        }

        project.pbxproj.objects.append(PBXObject.pbxGroup(destinationGroup))
        try project.write(path: projectPath)

        completion?()
    }

    private func createModuleGroupIfNeed() throws {

        guard var project = project else {
            throw Generator.Error.cantFindProject
        }

        var groupIndex: Int?
        for (index, value) in project.pbxproj.objects.lazy.enumerated() {
            if case let PBXObject.pbxGroup(group) = value, group.path == Path(info.destinationPath).lastComponent {
                groupIndex = index
                break
            }
        }

        guard let index = groupIndex,
            case var PBXObject.pbxGroup(group) = project.pbxproj.objects.remove(at: index) else {
            throw Generator.Error.wrongDestinationGroup
        }

        if info.isFolderRequired {
            let refString = project.pbxproj.generateUUID(for: PBXGroup.self)
            destinationGroup = PBXGroup(
                reference: refString,
                children: [],
                sourceTree: .group,
                name: nil,
                path: info.moduleName
            )
            group.children.append(refString)
            project.pbxproj.objects.append(PBXObject.pbxGroup(group))
        } else {
            destinationGroup = group
        }

        self.project = project
    }

    private func createFolderIfNeed() throws {

        if info.isFolderRequired {
            guard let destinationFolderPath = destinationFolderPath else {
                throw Generator.Error.wrongDestinationPath
            }
            let newPath = destinationFolderPath + Path(info.moduleName)
            guard !newPath.exists else {
                throw Generator.Error.destinationAlreadyExist
            }
            self.destinationFolderPath = newPath
            try newPath.mkdir()
        }
    }

    private func checkProjectFile() throws {

        guard let projectPath = Path.current.glob("*.xcodeproj").first else {
            throw Generator.Error.cantFindProject
        }
        self.projectPath = projectPath
        project = try XcodeProj(path: projectPath.absolute())
    }

    private func checkDestinationPath() throws {

        destinationFolderPath = Path(info.destinationPath)
        guard destinationFolderPath?.exists == true else {
            throw Generator.Error.noDestinationPath
        }
    }

    private func checkTemplatePath() throws {

        templateFolderPath = Path.current + Path("Templates") + Path(info.templateName)
        guard templateFolderPath?.exists == true else {
            throw Generator.Error.wrongTemplateName
        }
    }
}
