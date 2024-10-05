// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Battery",
    platforms: [.iOS(.v15), .macOS(.v13)],
    products: [
        .library(
            name: "Battery",
            type: .dynamic,
            targets: ["Battery"]),
    ],
    dependencies: [
        .package(url: "https://github.com/migueldeicaza/SwiftGodot", revision: "main"),
    ],
    targets: [
        .target(
            name: "Battery",
            dependencies: [
                .product(name: "SwiftGodot", package: "SwiftGodot")
            ]),
    ]
)
