//
// Environment.swift
// SwiftyFriend
//
// Created by Igor Tarasenko
//

import Foundation

public func getEnvironmentVar(_ name: String) -> String? {

    guard let rawValue = getenv(name) else { return nil }
    return String(utf8String: rawValue)
}

public func setEnvironmentVar(name: String, value: String, overwrite: Bool) {

    setenv(name, value, overwrite ? 1 : 0)
}
