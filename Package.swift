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
        .library(name: "PackageManifestGeneratorCore", targets: ["PackageManifestGeneratorCore"]),
        .plugin(name: "ManifestGeneratorPlugin", targets: ["ManifestGeneratorPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
        .package(url: "https://github.com/johnsundell/files.git", from: "4.0.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.6"),
        .package(url: "https://github.com/mobelux/swift-version-file-plugin.git", from: "0.2.0")
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
            ]
        ),
        .testTarget(
            name: "PackageManifestGeneratorCoreTests",
            dependencies: [
                "PackageManifestGeneratorCore"
            ]
        ),
        .plugin(
            name: "ManifestGeneratorPlugin",
            capability: .command(
                intent: .custom(
                    verb: "generate-manifest",
                    description: "Updates package manifest."
                ),
                permissions: [
                    .writeToPackageDirectory(reason: "Update package manifest.")
                ]
            ),
            dependencies: [
                "package-manifest-generator"
            ]
        )
    ]
)
