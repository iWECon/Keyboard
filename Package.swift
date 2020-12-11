// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Keyboard",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "Keyboard", targets: ["Keyboard"]),
        .library(name: "KeyboardNotifiable", targets: ["KeyboardNotifiable"])
    ],
    targets: [
        .target(name: "Keyboard", dependencies: []),
        .target(name: "KeyboardNotifiable", dependencies: ["Keyboard"]),
        .testTarget(name: "KeyboardTests", dependencies: ["Keyboard"]),
    ]
)
