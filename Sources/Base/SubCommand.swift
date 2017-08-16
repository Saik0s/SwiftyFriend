//
// SubCommand.swift
// SwiftyFriend
//
// Created by Igor Tarasenko
//

import Foundation
import Commander

public class InputArgument {
    public let argument: CommandArgumentInterface
    public let value:    Any

    public init<T>(argument: CommandArgument<T>, value: T) {

        self.argument = argument
        self.value = value
    }

    public init(argument: CommandArgumentInterface, value: String) {

        self.argument = argument
        self.value = value
    }
}

public protocol SubCommandInterface: CommandType {
    var options: [CommandArgumentInterface] { get }

    func execute(with arguments: [InputArgument]) throws
}

// MARK: - CommandType
extension SubCommandInterface {
    public func run(_ parser: ArgumentParser) throws {

        let inputs: [InputArgument] = try self.options.flatMap { argument in
            var value: String
            switch argument.type {
                case let .flag(name, alias, isBool):
                    if isBool {
                        value = try Flag(
                                name,
                                flag: alias.first,
                                disabledName: nil,
                                disabledFlag: nil,
                                description: argument.desc,
                                default: false
                        ).parse(parser).description
                    } else {
                        value = try Option(name, "", flag: alias.first, description: argument.desc).parse(parser)
                    }
                case .unnamed:
                    value = try Argument<String>(argument.desc).parse(parser)
            }
            return InputArgument(argument: argument, value: value)
        }

        if !parser.isEmpty {
            throw BaseError.unknownArgument(parser.remainder.joined(separator: "\n"))
        }

        try execute(with: inputs)
    }
}
