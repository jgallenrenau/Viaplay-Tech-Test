// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Domain",
    platforms: [ .iOS(.v16), .macOS(.v12) ],
    products: [ .library(name: "Domain", targets: ["Domain"]) ],
    targets: [ .target(name: "Domain"), .testTarget(name: "DomainTests", dependencies: ["Domain"]) ]
)


