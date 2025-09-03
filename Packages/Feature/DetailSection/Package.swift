// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DetailSection",
    platforms: [
        .iOS(.v16),
        .macOS(.v12)
    ],
    products: [
        .library(name: "DetailSection", targets: ["DetailSection"])
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../DSKit"),
        .package(path: "../Data")
    ],
    targets: [
        .target(name: "DetailSection", dependencies: ["Domain", "DSKit", "Data"]),
        .testTarget(name: "DetailSectionTests", dependencies: ["DetailSection"])
    ]
)


