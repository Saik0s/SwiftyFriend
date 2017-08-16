//
// CommandArgument.swift
// SwiftyFriend
//
// Created by Igor Tarasenko
//

import Foundation

public protocol CommandArgumentValueType {
}

extension Bool: CommandArgumentValueType {
}

extension String: CommandArgumentValueType {
}

extension Int: CommandArgumentValueType {
}

extension Double: CommandArgumentValueType {
}

public enum CommandArgumentType {
    case flag(name: String, alias: String, isBool: Bool)
    case unnamed(position: Int)
}

public protocol CommandArgumentInterface {
    var type: CommandArgumentType { get }
    var desc: String { get }
    var help: String { get }
    var isRequired: Bool { get }
}

public class CommandArgument<V: CommandArgumentValueType>: CommandArgumentInterface {
    public typealias ValueType = V
    public let type: CommandArgumentType
    public let desc: String
    public let help: String
    public let isRequired: Bool

    public init(type: CommandArgumentType, desc: String, help: String = "", isRequired: Bool = true) {

        self.type = type
        self.desc = desc
        self.help = help
        self.isRequired = isRequired
    }
}

extension CommandArgumentType {
    public func argument<T>(
        valueType: T.Type,
        desc: String,
        help: String = "",
        required: Bool = true
    ) -> CommandArgument<T> {

        return CommandArgument<T>(type: self, desc: desc, help: help, isRequired: required)
    }
}
