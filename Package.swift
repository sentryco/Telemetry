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
    dependencies: [],
    targets: [
        .target(
            name: "Telemetry",
            dependencies: []),
        .testTarget(
            name: "TelemetryTests",
            dependencies: ["Telemetry"])
    ]
)
