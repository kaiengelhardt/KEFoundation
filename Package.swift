// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "KEFoundation",
    platforms: [
        .iOS(.v14),
        .macCatalyst(.v14)
    ],
    products: [
        .library(
            name: "KEFoundation",
            targets: ["KEFoundation"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "KEFoundation",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "KEFoundation Unit Tests",
            dependencies: ["KEFoundation"],
            path: "Unit Tests"
        ),
    ]
)
