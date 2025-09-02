// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SectionsFeature",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "SectionsFeature", targets: ["SectionsFeature"])
    ],
    dependencies: [
        .package(path: "../CoreKit"),
        .package(path: "../DSKit"),
        .package(path: "../APIClient")
    ],
    targets: [
        .target(name: "SectionsFeature", dependencies: ["CoreKit", "DSKit", "APIClient"])
    ]
)


