// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyFriend",
     products: [
        .library(name: "SwiftyFriendKit", targets: ["SwiftyFriendKit"]),
        .executable(name: "swifty-friend", targets: ["SwiftyFriend"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0"),
        // .package(url: "https://github.com/Quick/Quick.git", from: "1.2.0"),
        // .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.3"),
    ],
    targets: [
        .target(
            name: "SwiftyFriendKit", 
            dependencies: []
        ),
        .testTarget(
            name: "SwiftyFriendKitTests",
            dependencies: ["SwiftyFriendKit"]//, "Quick", "Nimble"]
        ),
        .target(
            name: "SwiftyFriend",
            dependencies: ["SwiftyFriendKit", "Utility"]
        ),
    ],
    swiftLanguageVersions: [4]
)
