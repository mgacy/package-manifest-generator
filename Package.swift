// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "package-manifest-generator",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(name: "package-manifest-generator", targets: ["package-manifest-generator"]),
        .library(name: "PackageManifestGeneratorCore", targets: ["PackageManifestGeneratorCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/johnsundell/files.git", from: "4.0.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.6")
    ],
    targets: [
        .executableTarget(
            name: "package-manifest-generator",
            dependencies: [
                "PackageManifestGeneratorCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .target(
            name: "PackageManifestGeneratorCore",
            dependencies: [
                .product(name: "Files", package: "Files"),
                .product(name: "Yams", package: "Yams")
            ]),
        .testTarget(
            name: "PackageManifestGeneratorCoreTests",
            dependencies: ["PackageManifestGeneratorCore"]
        )
    ]
)
