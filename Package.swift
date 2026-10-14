// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "VideoTrimmerKit",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "VideoTrimmerKit", targets: ["VideoTrimmerKit"])
    ],
    targets: [
        .target(name: "VideoTrimmerKit"),
        .testTarget(name: "VideoTrimmerKitTests", dependencies: ["VideoTrimmerKit"])
    ]
)
