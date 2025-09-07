// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Data",
    platforms: [
        .iOS(.v16),
        .macOS(.v12),
        .tvOS(.v16)
    ],
    products: [
        .library(name: "Data", targets: ["Data"])
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../../Infraestructure/NetworkingKit"),
        .package(path: "../../Infraestructure/StorageKit")
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: ["Domain", "NetworkingKit", "StorageKit"]
        ),
        .testTarget(
            name: "DataTests",
            dependencies: ["Data"]
        )
    ]
)
