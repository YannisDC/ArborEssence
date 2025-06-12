// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "ArborEssence",
    products: [
        .library(
            name: "ArborEssence",
            targets: ["ArborEssence"]),
    ],
    targets: [
        .target(
            name: "ArborEssence"),
        .testTarget(
            name: "ArborEssenceTests",
            dependencies: ["ArborEssence"]
        ),
    ]
)
