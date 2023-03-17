// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Telemetry",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Telemetry",
            targets: ["Telemetry"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Telemetry",
            dependencies: []),
        .testTarget(
            name: "TelemetryTests",
            dependencies: ["Telemetry"])
    ]
)
