//
// GeneratorError.swift
// SwiftyFriend
//
// Created by Igor Tarasenko
//

import Foundation

extension Generator.Error {
    public var code: Int {

        switch self {
        case .wrongArguments:
            return 1
        case .noTemplateName:
            return 2
        case .noModuleName:
            return 3
        case .noDestinationPath:
            return 4
        case .wrongTemplateName:
            return 5
        case .wrongDestinationPath:
            return 6
        case .wrongDestinationGroup:
            return 7
        case .cantCreateFiles:
            return 8
        case .incorrectTemplate:
            return 9
        case .cantFindProject:
            return 10
        case .destinationAlreadyExist:
            return 11
        }
    }
}

extension Generator.Error: CustomStringConvertible {

    public var description: String {
        return rawValue
    }
}
