// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DSKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "DSKit", targets: ["DSKit"])
    ],
    dependencies: [
        .package(path: "../CoreKit")
    ],
    targets: [
        .target(name: "DSKit", dependencies: ["CoreKit"]),
        .testTarget(name: "DSKitTests", dependencies: ["DSKit"])
    ]
)


