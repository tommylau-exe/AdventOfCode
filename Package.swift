// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "AdventOfCode",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    ],
    targets: [
        .executableTarget(
            name: "AdventOfCode",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            resources: [
                .copy("Resources"),
            ]
        ),
    ]
)
