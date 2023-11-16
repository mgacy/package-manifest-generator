// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [
        .macOS(.v11),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(url: "https://github.com/johnsundell/files.git", from: "4.0.0")
    ]
)
