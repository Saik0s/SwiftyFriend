//
// main.swift
// SwiftyFriend
//
// Created by Igor Tarasenko
//

import Foundation

public let cli: CLI = CLI()
do {
    try cli.run {
        exit(0)
    }
} catch {
    print("Whoops! An error occurred: \(error)")
}
