// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SpaceDataStructures",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .executable(name: "SpaceDataStructures", targets: ["SpaceDataStructures"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "SpaceDataStructures",
            dependencies: [],
            path: "."
        )
    ]
) 