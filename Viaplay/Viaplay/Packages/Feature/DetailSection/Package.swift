// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DetailSection",
    platforms: [
        .iOS(.v16),
        .macOS(.v12)
    ],
    products: [
        .library(name: "DetailSection", targets: ["DetailSection"])
    ],
    dependencies: [
        .package(path: "../../Base/Domain"),
        .package(path: "../../Infraestructure/DSKit"),
        .package(path: "../../Base/Data")
    ],
    targets: [
        .target(name: "DetailSection", dependencies: ["Domain", "DSKit", "Data"]),
        .testTarget(name: "DetailSectionTests", dependencies: ["DetailSection"])
    ]
)
