// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DataKit",
    platforms: [ .iOS(.v16) ],
    products: [ .library(name: "DataKit", targets: ["DataKit"]) ],
    dependencies: [
        .package(path: "../DomainKit"),
        .package(path: "../NetworkingKit"),
        .package(path: "../StorageKit")
    ],
    targets: [
        .target(name: "DataKit", dependencies: ["DomainKit", "NetworkingKit", "StorageKit"]),
        .testTarget(name: "DataKitTests", dependencies: ["DataKit"]) 
    ]
)


