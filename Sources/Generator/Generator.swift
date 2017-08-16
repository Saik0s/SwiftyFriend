//
// Generator.swift
// SwiftyFriend
//
// Created by Igor Tarasenko
//

import Base

public struct Generator: SubCommandInterface {

    private var completion: CompletionHandler?

    public enum Error: String, Swift.Error {
        case wrongArguments
        case noTemplateName
        case noModuleName
        case noDestinationPath
        case wrongTemplateName
        case wrongDestinationPath
        case wrongDestinationGroup
        case cantCreateFiles
        case incorrectTemplate
        case cantFindProject
        case destinationAlreadyExist
    }

    public let options: [CommandArgumentInterface] = {
        [CommandArgumentInterface](
            arrayLiteral: CommandArgument<String>(type: .unnamed(position: 0), desc: "template name"),
            CommandArgument<String>(type: .unnamed(position: 1), desc: "module name"),
            CommandArgument<String>(type: .unnamed(position: 2), desc: "destination folder"),
            CommandArgument<String>(
                type: .flag(name: "group", alias: "g", isBool: false),
                desc: "destination group",
                isRequired: false
            ),
            CommandArgument<String>(
                type: .flag(name: "folder", alias: "f", isBool: true),
                desc: "create folder",
                isRequired: false
            )
        )
    }()

    public init(completion: CompletionHandler? = nil) {

        self.completion = completion
    }

    public func execute(with arguments: [InputArgument]) throws {

        guard arguments.count >= 3 else {
            throw Generator.Error.wrongArguments
        }

        guard let templateName = arguments[0].value as? String,
            let moduleName = arguments[1].value as? String,
            let destinationPath = arguments[2].value as? String else {
            throw Generator.Error.wrongArguments
        }

        var destinationGroup: String = moduleName
        var isFolderRequired: Bool = false

        if arguments.count >= 4 {
            if let value = arguments[3].value as? String {
                destinationGroup = value
                isFolderRequired = arguments.count >= 5
            } else {
                isFolderRequired = true
            }
        }

        let info = try TemplateInfo(
            moduleName: moduleName,
            templateName: templateName,
            destinationPath: destinationPath,
            destinationGroup: destinationGroup.emptyAsNil,
            isFolderRequired: isFolderRequired
        )

        do {
            try TemplateEngine(with: info).generate(with: completion)
        } catch let error as Error {
            throw error
        }
    }
}
