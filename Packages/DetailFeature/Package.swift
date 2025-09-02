// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DetailFeature",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "DetailFeature", targets: ["DetailFeature"])
    ],
    dependencies: [
        .package(path: "../CoreKit"),
        .package(path: "../DSKit"),
        .package(path: "../APIClient")
    ],
    targets: [
        .target(name: "DetailFeature", dependencies: ["CoreKit", "DSKit", "APIClient"])
    ]
)


