//
//  SourceGeneratorTests.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 1/25/24.
//

@testable import PackageManifestGeneratorCore
import CustomDump
import Foundation
import XCTest

final class SourceGeneratorTests: XCTestCase {
    let sut = SourceGenerator.self
}

// MARK: - Products
extension SourceGeneratorTests {
    func testExecutableTarget() {
        let expected = """
            .executable(name: "Target", targets: ["Target"])
            """

        let targetName = "Target"
        let actual = sut.product(
            Product(
                name: targetName,
                type: .executable,
                targets: [targetName]))

        expectNoDifference(actual, expected)
    }

    func testUnspecifiedLibraryProduct() {
        let expected = """
            .library(name: "Target", targets: ["Target"])
            """

        let targetName = "Target"
        let actual = sut.product(
            Product(
                name: targetName,
                type: .library(nil),
                targets: [targetName]))

        expectNoDifference(actual, expected)
    }

    func testStaticLibraryProduct() {
        let expected = """
            .library(name: "Target", type: .static, targets: ["Target"])
            """

        let targetName = "Target"
        let actual = sut.product(
            Product(
                name: targetName,
                type: .library(.static),
                targets: [targetName]))

        expectNoDifference(actual, expected)
    }

    func testDynamicLibraryProduct() {
        let expected = """
            .library(name: "Target", type: .dynamic, targets: ["Target"])
            """

        let targetName = "Target"
        let actual = sut.product(
            Product(
                name: targetName,
                type: .library(.dynamic),
                targets: [targetName]))

        expectNoDifference(actual, expected)
    }

    func testMultipleTargets() {
        let expected = """
            .library(name: "Library", targets: ["Target1", "Target2"])
            """

        let actual = sut.product(
            Product(
                name: "Library",
                type: .library(nil),
                targets: ["Target1", "Target2"]))

        expectNoDifference(actual, expected)
    }

    func testPluginTarget() {
        let expected = """
            .plugin(name: "Target", targets: ["Target"])
            """

        let targetName = "Target"
        let actual = sut.product(
            Product(
                name: targetName,
                type: .plugin,
                targets: [targetName]))

        expectNoDifference(actual, expected)
    }
}

// MARK: - Dependencies
extension SourceGeneratorTests {
    func testTargetItemDependency() {
        let expected = """
            "Target"
            """

        let actual = sut.dependency(
            .targetItem(name: "Target"))

        expectNoDifference(actual, expected)
    }

    func testProductItemDependency() {
        let expected = """
            .product(name: "Product", package: "Package")
            """

        let actual = sut.dependency(
            .productItem(name: "Product", package: "Package"))

        expectNoDifference(actual, expected)
    }

    func testPackagelessProductItemDependency() {
        let expected = """
            .product(name: "Product")
            """

        let actual = sut.dependency(
            .productItem(name: "Product", package: nil))

        expectNoDifference(actual, expected)
    }

    func testByNameDependency() {
        let expected = """
            .byName(name: "Name")
            """

        let actual = sut.dependency(
            .byNameItem(name: "Name"))

        expectNoDifference(actual, expected)
    }
}

// MARK: - Resources
extension SourceGeneratorTests {
    func testCopyResource() {
        let expected = """
            .copy("Path")
            """

        let actual = sut.resource(
            Target.Resource(rule: .copy, path: "Path"))

        expectNoDifference(actual, expected)
    }

    func testEmbedResource() {
        let expected = """
            .embedInCode("Path")
            """

        let actual = sut.resource(
            Target.Resource(rule: .embedInCode, path: "Path"))

        expectNoDifference(actual, expected)
    }

    func testProcessResource() {
        let expected = """
            .process("Path")
            """

        let actual = sut.resource(
            Target.Resource(rule: .process(nil), path: "Path"))

        expectNoDifference(actual, expected)
    }

    func testProcessBaseLocalizationResource() {
        let expected = """
            .process("Path", localization: .base)
            """

        let actual = sut.resource(
            Target.Resource(rule: .process(.base), path: "Path"))

        expectNoDifference(actual, expected)
    }

    func testProcessDefaultLocalizationResource() {
        let expected = """
            .process("Path", localization: .default)
            """

        let actual = sut.resource(
            Target.Resource(rule: .process(.default), path: "Path"))

        expectNoDifference(actual, expected)
    }
}

// MARK: - Plugins
extension SourceGeneratorTests {
    func testPlugin() {
        let expected = """
            .plugin(name: "Plugin", package: "plugin")
            """

        let actual = sut.plugin(Target.PluginUsage(name: "Plugin", package: "plugin"))

        expectNoDifference(actual, expected)
    }

    func testPackagelessPlugin() {
        let expected = """
            .plugin(name: "Plugin")
            """

        let actual = sut.plugin(Target.PluginUsage(name: "Plugin", package: nil))

        expectNoDifference(actual, expected)
    }
}

// MARK: - Targets
extension SourceGeneratorTests {
    func testMinimalTarget() {
        let expected = """
            .target(
                name: "Target"
            )
            """

        let target = Target(name: "Target")
        let sut = SourceGenerator(indentationStyle: .fourSpaces)
        let actual = sut.target(target)

        expectNoDifference(actual, expected)
    }

    func testComplexTarget() {
        let expected = """
            .executableTarget(
                name: "executable-target",
                dependencies: [
                    "MyTarget",
                    .product(name: "MyProduct", package: "my-product")
                ],
                path: "path/to/target",
                exclude: [
                    ".swiftlint.yml"
                ],
                sources: [
                    "source/path/1",
                    "source/path/2"
                ],
                resource: [
                    .copy("Resources")
                ],
                plugins: [
                    .plugin(name: "MyPlugin", package: "my-plugin")
                ]
            )
            """

        let target = Target(
            name: "executable-target",
            type: .executable,
            packageAccess: false,
            path: "path/to/target",
            sources: [
                "source/path/1",
                "source/path/2"
            ],
            resources: [
                Target.Resource(rule: .copy, path: "Resources")
            ],
            exclude: [
                ".swiftlint.yml"
            ],
            dependencies: [
                .targetItem(name: "MyTarget"),
                .productItem(name: "MyProduct", package: "my-product")
            ],
            plugins: [
                Target.PluginUsage(name: "MyPlugin", package: "my-plugin")
            ])
        let sut = SourceGenerator(indentationStyle: .fourSpaces)
        let actual = sut.target(target)

        expectNoDifference(actual, expected)
    }

    func testIndendation() {
        let expected = """
            .target(
              name: "Target"
            )
            """

        let target = Target(name: "Target")
        let sut = SourceGenerator(indentationStyle: .twoSpaces)
        let actual = sut.target(target)

        expectNoDifference(actual, expected)
    }
}
