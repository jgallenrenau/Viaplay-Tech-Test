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
    dependencies: [],
    targets: [
        .target(name: "DSKit"),
        .testTarget(name: "DSKitTests", dependencies: ["DSKit", "DomainKit"])
    ]
)


