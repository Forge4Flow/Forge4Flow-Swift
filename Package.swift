// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Forge4Flow-Swift",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Forge4Flow-Swift",
            targets: ["Forge4Flow-Swift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
//        .package(url: "https://github.com/outblock/fcl-swift.git", from: "0.1.1"),
        .package(name: "fcl-swift", path: "/Users/boiseitguru/Development/Flow/fcl-swift")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Forge4Flow-Swift",
            dependencies: [
                .product(name: "FCL", package: "fcl-swift"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "Forge4Flow-SwiftTests",
            dependencies: ["Forge4Flow-Swift"]),
    ]
)
