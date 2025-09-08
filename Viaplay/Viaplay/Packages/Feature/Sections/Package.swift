// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Sections",
    platforms: [
        .iOS(.v16),
        .macOS(.v12),
        .tvOS(.v16)
    ],
    products: [
        .library(name: "Sections", targets: ["Sections"])
    ],
    dependencies: [
        .package(path: "../../Base/Domain"),
        .package(path: "../../Infraestructure/DSKit"),
        .package(path: "../../Base/Data"),
        .package(path: "../../Infraestructure/NetworkingKit"),
        .package(path: "../../Infraestructure/StorageKit"),
        .package(path: "../DetailSection"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.12.0"),
        .package(url: "https://github.com/airbnb/lottie-ios", from: "4.3.0")
    ],
    targets: [
        .target(
            name: "Sections",
            dependencies: [
                "Domain", 
                "DSKit", 
                "Data", 
                "NetworkingKit", 
                "StorageKit", 
                "DetailSection",
                .product(name: "Lottie", package: "lottie-ios")
            ],
            path: "Sources/SectionsFeature",
            resources: []
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
