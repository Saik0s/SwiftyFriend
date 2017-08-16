//
// Base.swift
// SwiftyFriend
//
// Created by Igor Tarasenko
//

import Foundation

public typealias CompletionHandler = () -> Void

public enum BaseError: Swift.Error {
    case unknownArgument(String)
    case general
}

extension BaseError: CustomStringConvertible {
    public var description: String {

        switch self {
        case let .unknownArgument(arg):
            return "Unknown argument \(arg)"
        case .general:
            return "Error"
        }
    }
}
