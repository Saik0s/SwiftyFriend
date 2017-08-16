//
// TemplateContext.swift
// SwiftyFriend
//
// Created by Igor Tarasenko
//

import Foundation
import PathKit
import xcodeproj

public protocol TemplateContextType {
    var context: [String: Any] { get }
}

public enum TemplateContextKey {
    case name
    case date
    case file
    case developer
    case organization
    case module
    case unknown(String)
}

public enum TemplateContext {
    case basic(name: String, file: String)
}

extension TemplateContextKey: ExpressibleByStringLiteral {

    public init(stringLiteral value: StringLiteralType) {

        switch value {
        case "name": self = .name
        case "date": self = .date
        case "file": self = .file
        case "developer": self = .developer
        case "organization": self = .organization
        case "module": self = .module
        default: self = .unknown(value)
        }
    }

    public init(unicodeScalarLiteral value: String) {

        self.init(stringLiteral: value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {

        self.init(stringLiteral: value)
    }

    public init(_ value: String) {

        self.init(stringLiteral: value)
    }
}

extension TemplateContextKey: Hashable {
    public var hashValue: Int { return description.hashValue }

    public static func ==(
        lhs: TemplateContextKey,
        rhs: TemplateContextKey
    ) -> Bool { return lhs.description == rhs.description }
}

extension TemplateContextKey: CustomStringConvertible {

    public var description: String {

        switch self {
        case .name: return "name"
        case .date: return "date"
        case .file: return "file"
        case .developer: return "developer"
        case .organization: return "organization"
        case .module: return "module"
        case let .unknown(key): return key
        }
    }
}

extension TemplateContext: TemplateContextType {

    public var context: [String: Any] {
        switch self {
        case let .basic(name, file):
            // TODO:
            guard let projectPath = Path.current.glob("*.xcodeproj").first else {
                return [:]
            }
            do {
                let project = try XcodeProj(path: projectPath)
                let module = projectPath.lastComponentWithoutExtension
                let date = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
                let developer = NSFullUserName()
                let organization = project.pbxproj.objects.projects.first?.attributes["ORGANIZATIONNAME"] ?? ""
                // @formatter:off
                return [
                    TemplateContextKey.name.description: name,
                    TemplateContextKey.date.description: date,
                    TemplateContextKey.file.description: file,
                    TemplateContextKey.developer.description: developer,
                    TemplateContextKey.organization.description: organization,
                    TemplateContextKey.module.description: module
                ]
            } catch {
                return [:]
            }
        }
    }
}
