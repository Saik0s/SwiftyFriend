//
// CLI.swift
// SwiftyFriend
//
// Created by Igor Tarasenko
//

import Foundation
import Generator
import Commander
import Base
import CLISpinner

public enum CommandType {
    case help
    case rswift
    case linter
    case version
    case sourcery
    case generator
    case formatter
    case phaseInjector
}

private var spinner = Spinner(pattern: .dots)
public class CLI {

    public func run(with completion: @escaping () -> Void) throws {

        atexit { spinner.unhideCursor() }
        spinner.start()
        Group {
            $0.command("help", description: "help command") { (_: String) in
                print("Selected help")
            }
            $0.command("rswift", description: "rswift command") { (_: String) in
                print("Selected rswift")
            }
            $0.command("linter", description: "linter command") { (_: String) in
                print("Selected linter")
            }
            $0.command("version", description: "version command") { (_: String) in
                print("Selected version")
            }
            $0.command("sourcery", description: "sourcery command") { (_: String) in
                print("Selected sourcery")
            }
            $0.addCommand("generator", Generator { spinner.succeed() })
            $0.command("formatter", description: "formatter command") { (_: String) in
                print("Selected formatter")
            }
            $0.command("phaseInjector", description: "phaseInjector command") { (_: String) in
                print("Selected phaseInjector")
            }
        }.run("0.0.1")
    }
}
