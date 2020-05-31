// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Minimalist",
    swiftLanguageVersions: [.v5_1, .v5_2]
    platforms: [
        .macOS(.v10_10), .iOS(.v12), .tvOS(.v12), .watchOS(.v5)
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
