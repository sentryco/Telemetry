// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Telemetry",
    platforms: [.iOS(.v13), .macOS(.v12)],
    products: [
        .library(
            name: "Telemetry",
            targets: ["Telemetry"])
    ],
    dependencies: [
      .package(url: "https://github.com/eonist/JSONSugar.git", branch: "master")
    ],
    targets: [
        .target(
            name: "Telemetry",
            dependencies: ["JSONSugar"]),
        .testTarget(
            name: "TelemetryTests",
            dependencies: ["Telemetry"])
    ]
)
