// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "fp",
    products: [
        .library(
            name: "fp",
            targets: ["fp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-nonempty", from: "0.3.1"),
    ],
    targets: [
        .target(
            name: "fp",
            dependencies: [.product(name: "NonEmpty", package: "swift-nonempty")],
            path: "Sources"),
        .testTarget(
            name: "fpTests",
            dependencies: ["fp"]),
    ]
)
