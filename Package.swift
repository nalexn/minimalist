// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Minimalist",
    platforms: [
        .macOS(.v10_15), .iOS(.v12), .tvOS(.v12)
    ],
    products: [
        .library(name: "Minimalist", targets: ["Minimalist"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Minimalist", dependencies: []),
        .testTarget( name: "MinimalistTests", dependencies: ["Minimalist"]),
    ]
)
