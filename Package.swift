// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnalyticsFramework",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "AnalyticsFramework",
            targets: ["AnalyticsFramework"]
        ),
    ],
    targets: [
        .target(
            name: "AnalyticsFramework",
            dependencies: []
        ),
        .testTarget(
            name: "AnalyticsFrameworkTests",
            dependencies: ["AnalyticsFramework"]
        )
    ]
)
