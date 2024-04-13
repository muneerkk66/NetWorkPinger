// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkPinger",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NetworkPinger",
            targets: ["NetworkPinger"])
    ],
    dependencies: [.package(url: "https://github.com/samiyr/SwiftyPing.git", branch: "master")],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NetworkPinger",
            dependencies: ["SwiftyPing"]),
        .testTarget(
            name: "NetworkPingerTests",
            dependencies: ["NetworkPinger"])
    ]
)
