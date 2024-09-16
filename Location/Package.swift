// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Location",
    platforms: [.iOS(.v15), .macOS(.v13)],
    products: [
        .library(
            name: "Location",
            type: .dynamic,
            targets: ["Location"]),
    ],
    dependencies: [
        .package(url: "https://github.com/migueldeicaza/SwiftGodot", revision: "main"),
    ],
    targets: [
        .target(
            name: "Location",
            dependencies: [
                .product(name: "SwiftGodot", package: "SwiftGodot")
            ]),
    ]
)
