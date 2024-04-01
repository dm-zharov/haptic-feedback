// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HapticFeedback",
    platforms: [.iOS(.v14), .macCatalyst(.v14), .macOS(.v11), .tvOS(.v14), .watchOS(.v7)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "HapticFeedback",
            targets: ["HapticFeedback"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "HapticFeedback"),
        .testTarget(
            name: "HapticFeedbackTests",
            dependencies: ["HapticFeedback"]),
    ]
)
