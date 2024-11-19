// swift-tools-version: 5.9
import PackageDescription // imports the PackageDescription module

let package = Package( // initializes a new package
    name: "Telemetry", // sets the package name to "Telemetry"
    platforms: [.iOS(.v17), .macOS(.v14)], // sets the supported platforms to iOS 15 and macOS 12
    products: [ // defines the products of the package
        .library( // creates a new library product
            name: "Telemetry", // sets the library name to "Telemetry"
            targets: ["Telemetry"]) // sets the library target to "Telemetry"
    ],
    dependencies: [ // defines the package dependencies
      .package(url: "https://github.com/eonist/JSONSugar.git", branch: "master") // adds a dependency to the JSONSugar package
    ],
    targets: [ // defines the package targets
        .target( // creates a new target
            name: "Telemetry", // sets the target name to "Telemetry"
            dependencies: ["JSONSugar"]), // sets the target dependencies to the JSONSugar package
        .testTarget( // creates a new test target
            name: "TelemetryTests", // sets the test target name to "TelemetryTests"
            dependencies: ["Telemetry"]) // sets the test target dependencies to the Telemetry target
    ]
)
