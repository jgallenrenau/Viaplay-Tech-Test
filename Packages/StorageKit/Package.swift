// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "StorageKit",
    platforms: [ .iOS(.v16) ],
    products: [ .library(name: "StorageKit", targets: ["StorageKit"]) ],
    targets: [ .target(name: "StorageKit"), .testTarget(name: "StorageKitTests", dependencies: ["StorageKit"]) ]
)


