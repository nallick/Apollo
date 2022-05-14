// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Apollo",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Apollo", targets: ["Apollo"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nallick/BaseSwift.git", from: "1.1.2"),
        .package(url: "https://github.com/nallick/Reflection.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Apollo",
            dependencies: [
                .product(name: "Reflection", package: "Reflection", condition: .when(platforms: [.iOS])),
            ]),
        .testTarget(
            name: "ApolloTests",
            dependencies: [
                "Apollo",
                .product(name: "BaseSwiftMocks", package: "BaseSwift"),
                .product(name: "Reflection", package: "Reflection", condition: .when(platforms: [.iOS])),
            ]),
    ]
)
