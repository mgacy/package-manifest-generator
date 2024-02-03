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
