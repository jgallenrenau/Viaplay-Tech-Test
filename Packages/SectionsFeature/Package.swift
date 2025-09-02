// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SectionsFeature",
    platforms: [
        .iOS(.v16),
        .macOS(.v12)
    ],
    products: [
        .library(name: "SectionsFeature", targets: ["SectionsFeature"])
    ],
    dependencies: [
        .package(path: "../DomainKit"),
        .package(path: "../DSKit"),
        .package(path: "../DataKit")
    ],
    targets: [
        .target(name: "SectionsFeature", dependencies: ["DomainKit", "DSKit", "DataKit"])
    ]
)


