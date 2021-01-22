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
        .library(name: "KeyboardNotifiable", targets: ["KeyboardNotifiable"]),
        .library(name: "KeyboardResponder", targets: ["KeyboardResponder"])
    ],
    dependencies: [
        .package(name: "WeakObserver", url: "https://github.com/iWECon/WeakObserver", from: "2.0.0"),
    ],
    targets: [
        .target(name: "Keyboard", dependencies: ["WeakObserver"]),
        .target(name: "KeyboardNotifiable", dependencies: ["Keyboard", "WeakObserver"]),
        .target(name: "KeyboardResponder", dependencies: ["WeakObserver"]),
        .testTarget(name: "KeyboardTests", dependencies: ["Keyboard"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
