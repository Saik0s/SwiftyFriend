//
// Optional+empty.swift
// SwiftyFriend
//
// Created by Igor Tarasenko
//

import Foundation

public protocol EmptiedContainer {
    var isEmpty: Bool { get }
}

extension String: EmptiedContainer {
}

extension Array: EmptiedContainer {
}

extension Optional where Wrapped: EmptiedContainer {
    public var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

extension Optional {
    @discardableResult
    public func ifSome(_ handler: (Wrapped) -> Void) -> Optional {

        switch self {
        case let .some(wrapped):
            handler(wrapped)
            return self
        case .none:
            return self
        }
    }

    @discardableResult
    public func ifNone(_ handler: () -> Void) -> Optional {

        switch self {
        case .some:
            return self
        case .none:
            handler()
            return self
        }
    }
}

extension EmptiedContainer {
    public var emptyAsNil: Self? {
        return isEmpty ? nil : self
    }

    public func throwOnEmpty() throws -> Self {
        guard !isEmpty else {
            throw BaseError.general
        }
        return self
    }
}
