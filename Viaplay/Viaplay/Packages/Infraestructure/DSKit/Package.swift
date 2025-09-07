// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DSKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v12),
        .tvOS(.v16)
    ],
    products: [
        .library(name: "DSKit", targets: ["DSKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.12.0"),
        .package(url: "https://github.com/airbnb/lottie-ios", from: "4.3.0")
    ],
    targets: [
        .target(
            name: "DSKit",
            dependencies: [
                .product(name: "Lottie", package: "lottie-ios")
            ]
        ),
        .testTarget(name: "DSKitTests", dependencies: ["DSKit", .product(name: "SnapshotTesting", package: "swift-snapshot-testing")])
    ]
)
