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
        .package(path: "../../Base≤ß/Domain"),
        .package(path: "../../Infraestructure/DSKit"),
        .package(path: "../../Base/Data"),
        .package(path: "../../Infraestructure/NetworkingKit"),
        .package(path: "../../Infraestructure/StorageKit"),
        .package(path: "../DetailSection"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.11.0")
    ],
    targets: [
        .target(
            name: "Sections",
            dependencies: ["Domain", "DSKit", "Data", "NetworkingKit", "StorageKit", "DetailSection"],
            path: "Sources/SectionsFeature",
            resources: [.process("../../Resources")]
        ),
        .testTarget(
            name: "SectionsUnitTests",
            dependencies: ["Sections"],
            path: "Tests/Unit"
        ),
        .testTarget(
            name: "SectionsIntegrationTests",
            dependencies: ["Sections"],
            path: "Tests/Integration"
        ),
        .testTarget(
            name: "SectionsSnapshotTests",
            dependencies: [
                "Sections",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests/Snapshot"
        )
    ]
)
