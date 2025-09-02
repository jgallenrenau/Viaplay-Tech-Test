// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DetailFeature",
    platforms: [
        .iOS(.v16),
        .macOS(.v12)
    ],
    products: [
        .library(name: "DetailFeature", targets: ["DetailFeature"])
    ],
    dependencies: [
        .package(path: "../DomainKit"),
        .package(path: "../DSKit"),
        .package(path: "../DataKit")
    ],
    targets: [
        .target(name: "DetailFeature", dependencies: ["DomainKit", "DSKit", "DataKit"]),
        .testTarget(name: "DetailFeatureTests", dependencies: ["DetailFeature"])
    ]
)


