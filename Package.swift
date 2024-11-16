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
    
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.57.0")
    ],
    
    targets: [
        .target(
            name: "AnalyticsFramework",
            dependencies: [],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        ),
        .testTarget(
            name: "AnalyticsFrameworkTests",
            dependencies: ["AnalyticsFramework"],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
        )
    ]
)
