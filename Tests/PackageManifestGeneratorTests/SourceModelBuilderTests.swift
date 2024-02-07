//
//  SourceModelBuilderTests.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 2/2/24.
//

@testable import PackageManifestGeneratorCore
import Foundation
import XCTest

final class SourceModelBuilderTests: XCTestCase {
    let sut = SourceModelBuilder()
}

// MARK: - Dependencies
extension SourceModelBuilderTests {
    func testMakeTargetDependency() {
        let expected = Target.Dependency.targetItem(name: "Dependency")

        let config = DependencyConfiguration(
            name: "Dependency",
            type: .target)
        let actual = sut.makeDependency(config)

        XCTAssertEqual(actual, expected)
    }

    func testMakeProductDependency() {
        let expected = Target.Dependency.productItem(
            name: "Dependency",
            package: "Package")

        let config = DependencyConfiguration(
            name: "Dependency",
            type: .product,
            package: "Package")
        let actual = sut.makeDependency(config)

        XCTAssertEqual(actual, expected)
    }

    func testMakeByNameDependency() {
        let expected = Target.Dependency.byNameItem(name: "Dependency")

        let config = DependencyConfiguration(
            name: "Dependency",
            type: .byName)
        let actual = sut.makeDependency(config)

        XCTAssertEqual(actual, expected)
    }
}

// MARK: - Resources
extension SourceModelBuilderTests {
    func testMakeCopyResource() throws {
        let expected = Target.Resource(
            rule: .copy,
            path: "Resources")

        let config = ResourceConfiguration(
            rule: .copy,
            path: "Resources")
        let actual = try sut.makeResource(config)

        XCTAssertEqual(actual, expected)
    }

    func testMakeEmbedInCodeResource() throws {
        let expected = Target.Resource(
            rule: .embedInCode,
            path: "Resources")

        let config = ResourceConfiguration(
            rule: .embed,
            path: "Resources")
        let actual = try sut.makeResource(config)

        XCTAssertEqual(actual, expected)
    }

    func testMakeProcessResource() throws {
        let expected = Target.Resource(
            rule: .process(nil),
            path: "Resources")

        let config = ResourceConfiguration(
            rule: .process,
            path: "Resources")
        let actual = try sut.makeResource(config)

        XCTAssertEqual(actual, expected)
    }

    func testMakeProcessResourceWithLocalization() throws {
        let expected = Target.Resource(
            rule: .process(.default),
            path: "Resources")

        let config = ResourceConfiguration(
            rule: .process,
            path: "Resources",
            localization: .default)
        let actual = try sut.makeResource(config)

        XCTAssertEqual(actual, expected)
    }

    func testMakeInvalidResource() throws {
        let config = ResourceConfiguration(
            rule: .copy,
            path: "Resources",
            localization: .default)

        XCTAssertThrows(
            try sut.makeResource(config),
            "Invalid Configuration")
    }
}

// MARK: - Targets
extension SourceModelBuilderTests {
    func testMakeTargetUsesTargetName() throws {
        let expectedName = "ConfigName"

        let config = TargetConfiguration(name: expectedName)
        let actual = try sut.makeTarget(
            directoryName: "DirectoryName",
            configuration: config)

        XCTAssertEqual(actual.name, expectedName)
    }

    func testMakeTargetFallbackName() throws {
        let expectedName = "DirectoryName"

        let config = TargetConfiguration(name: nil)
        let actual = try sut.makeTarget(
            directoryName: expectedName,
            configuration: config)

        XCTAssertEqual(actual.name, expectedName)
    }
}

// MARK: - Products
extension SourceModelBuilderTests {
    func testMakeExecutableProduct() {
        let expected = Product(
            name: "ProductName",
            type: .executable,
            targets: ["Target"])

        let config = SourceConfiguration.Product(
            type: .executable,
            name: "ProductName",
            targets: ["Target"])
        let actual = sut.makeProduct(config, targetName: "TargetName")

        XCTAssertEqual(actual, expected)
    }

    func testMakeUnspecifiedLibraryProduct() {
        let expected = Product(
            name: "ProductName",
            type: .library(nil),
            targets: ["Target"])

        let config = SourceConfiguration.Product(
            type: .library,
            name: "ProductName",
            targets: ["Target"])
        let actual = sut.makeProduct(config, targetName: "TargetName")

        XCTAssertEqual(actual, expected)
    }

    func testMakeDynamicLibraryProduct() {
        let expected = Product(
            name: "ProductName",
            type: .library(.dynamic),
            targets: ["Target"])

        let config = SourceConfiguration.Product(
            type: .dynamicLibrary,
            name: "ProductName",
            targets: ["Target"])
        let actual = sut.makeProduct(config, targetName: "TargetName")

        XCTAssertEqual(actual, expected)
    }

    func testProductUsesTargetName() {
        let expectedName = "Target"
        let expectedTargets = [expectedName]

        let config = SourceConfiguration.Product(type: .library)
        let actual = sut.makeProduct(config, targetName: expectedName)

        XCTAssertEqual(actual.name, expectedName)
        XCTAssertEqual(actual.targets, expectedTargets)
    }
}

// MARK: - Builder
extension SourceModelBuilderTests {
    func testBuilder() throws {
        let expectedRegularTarget = Target(
            name: "TargetName",
            type: .regular)
        let expectedTestTarget = Target(
            name: "TestTargetName",
            type: .test)
        let expectedProduct = Product(
            name: "ProductName",
            type: .library(nil),
            targets: ["Target"])

        let sourceConfig = Configuration(
            targetDirectory: .sources,
            directoryName: "SomeSourceDirectory",
            fileName: "config.yml",
            configuration: SourceConfiguration(
                type: .regular,
                target: TargetConfiguration(
                    name: "TargetName"
                ),
                products: [
                    SourceConfiguration.Product(
                        type: .library,
                        name: "ProductName",
                        targets: ["Target"])
                ]
            ))
        let testConfig = Configuration(
            targetDirectory: .tests,
            directoryName: "SomeTestDirectory",
            fileName: "SomeTestConfiguration",
            configuration: TestConfiguration(
                target: TargetConfiguration(
                    name: "TestTargetName"
                )))
        let (actualTargets, actualProducts) = try sut(sources: [sourceConfig], tests: [testConfig])!

        XCTAssertEqual(actualTargets, [expectedRegularTarget, expectedTestTarget])
        XCTAssertEqual(actualProducts, [expectedProduct])
    }

    func testBuilderError() throws {
        let sourceConfig = Configuration(
            targetDirectory: .sources,
            directoryName: "SomeSourceDirectory",
            fileName: "config.yml",
            configuration: SourceConfiguration(
                type: .regular,
                target: TargetConfiguration(
                    name: "TargetName",
                    resources: [
                        ResourceConfiguration(
                            rule: .copy,
                            path: "Resources",
                            localization: .default)
                    ])))

        XCTAssertThrows(
            try sut(sources: [sourceConfig]),
            "Invalid configuration at `/Sources/SomeSourceDirectory/config.yml`")
    }
}
