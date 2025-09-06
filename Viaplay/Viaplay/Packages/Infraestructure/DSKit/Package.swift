// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DSKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v12)
    ],
    products: [
        .library(name: "DSKit", targets: ["DSKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.12.0")
    ],
    targets: [
        .target(name: "DSKit"),
        .testTarget(name: "DSKitTests", dependencies: ["DSKit", .product(name: "SnapshotTesting", package: "swift-snapshot-testing")])
    ]
)
