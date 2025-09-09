// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DetailSection",
    platforms: [
        .iOS(.v16),
        .macOS(.v12),
        .tvOS(.v16)
    ],
    products: [
        .library(name: "DetailSection", targets: ["DetailSection"])
    ],
    dependencies: [
        .package(path: "../../Base/Domain"),
        .package(path: "../../Infraestructure/DSKit"),
        .package(path: "../../Base/Data"),
        .package(path: "../../Infraestructure/NetworkingKit"),
        .package(path: "../../Infraestructure/StorageKit"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.12.0"),
        .package(url: "https://github.com/airbnb/lottie-ios", from: "4.3.0")
    ],
    targets: [
        .target(
            name: "DetailSection",
            dependencies: [
                "Domain", 
                "DSKit", 
                "Data", 
                "NetworkingKit", 
                "StorageKit",
                .product(name: "Lottie", package: "lottie-ios")
            ],
            path: "Sources/DetailFeature",
            resources: []
        ),
        .testTarget(name: "DetailSectionUnitTests", dependencies: ["DetailSection"], path: "Tests/Unit"),
        .testTarget(name: "DetailSectionIntegrationTests", dependencies: ["DetailSection"], path: "Tests/Integration"),
        .testTarget(name: "DetailSectionSnapshotTests", dependencies: ["DetailSection", .product(name: "SnapshotTesting", package: "swift-snapshot-testing")], path: "Tests/Snapshot")
    ]
)
