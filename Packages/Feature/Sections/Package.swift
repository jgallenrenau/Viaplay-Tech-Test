// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Sections",
    platforms: [
        .iOS(.v16),
        .macOS(.v12)
    ],
    products: [
        .library(name: "Sections", targets: ["Sections"])
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../DSKit"),
        .package(path: "../Data")
    ],
    targets: [
        .target(name: "Sections", dependencies: ["Domain", "DSKit", "Data"]),
        .testTarget(name: "SectionsTests", dependencies: ["Sections"])
    ]
)


