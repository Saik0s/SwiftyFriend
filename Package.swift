// swift-tools-version:4.0

//@formatter:off
import PackageDescription

internal let package = Package(
    name: "SwiftyFriend",
    products: [
        .executable(name: "SwiftyFriend", targets: ["CLI", "Base", "Generator"])
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.6.1"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.8.0"),
        .package(url: "https://github.com/carambalabs/xcodeproj.git", from: "0.0.9"),
        .package(url: "https://github.com/kiliankoe/CLISpinner.git", from: "0.3.3"),
        .package(url: "https://github.com/kylef/Stencil.git", from: "0.8.0"),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", from: "2.0.1")
    ],
    targets: [
        .target(
            name: "CLI",
            dependencies: [
                "Base",
                "Generator",
                "Commander",
                "CLISpinner"
            ]
        ),
        .target(
            name: "Generator",
            dependencies: [
                "Base",
                "Stencil",
                "xcodeproj",
                "PathKit"
            ]
        ),
        .target(
            name: "Base",
            dependencies: [
                "Commander"
            ]
        ),
        .testTarget(
            name: "CLITests",
            dependencies: [
                "CLI"
            ]
        ),
        .testTarget(
            name: "GeneratorTests",
            dependencies: [
                "Generator"
            ],
            exclude: [
                "fixtures"
            ]
        )
    ],
    swiftLanguageVersions: [4]
)
