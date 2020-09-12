// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Minimalist",
    platforms: [
        .macOS(.v10_6), .iOS(.v10), .tvOS(.v12), .watchOS(.v5)
    ],
    products: [
        .library(name: "Minimalist", targets: ["Minimalist"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Minimalist", dependencies: []),
        .testTarget( name: "MinimalistTests", dependencies: ["Minimalist"]),
    ],
    swiftLanguageVersions: [.v5]
)
