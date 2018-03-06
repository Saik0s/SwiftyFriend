import SwiftyFriendKit
import Foundation
import Utility

// The first argument is always the executable, drop it
let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())

let parser = ArgumentParser(usage: "<options>", overview: "This is what this tool is for")
let number: OptionArgument<Int> = parser.add(option: "--number", shortName: "-n", kind: Int.self, usage: "A number to compute")
let uppercased: OptionArgument<Bool> = parser.add(option: "--uppercased", kind: Bool.self)

func processArguments(arguments: ArgumentParser.Result) {
    if let integer = arguments.get(number) {
        let message = "Your number is \(integer)"
        if arguments.get(uppercased) == true {
            print(message.uppercased())
        } else {
            print(message)
        }
    }
}

do {
    let parsedArguments = try parser.parse(arguments)
    processArguments(arguments: parsedArguments)
}
catch let error as ArgumentParserError {
    print(error.description)
}
catch let error {
    print(error.localizedDescription)
}