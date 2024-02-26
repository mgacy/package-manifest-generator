//
//  ConfigurationTests.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/19/23.
//

@testable import PackageManifestGeneratorCore
import CustomDump
import Foundation
import XCTest
import Yams

final class ConfigurationTests: XCTestCase {
    let decoder = YAMLDecoder()

    func decode<T: Decodable>(_ type: T.Type, from yaml: String) throws -> T {
        try decoder.decode(type.self, from: Data(yaml.utf8))
    }
}

// MARK: - GeneratorConfiguration
extension ConfigurationTests {
    func testDecodeMinimalGeneratorConfiguration() throws {
        let expected = GeneratorConfiguration()

        // Need to at least specify a member for YAMS to decode
        let yaml = """
            indentationStyle: ~
            """

        let actual = try decode(GeneratorConfiguration.self, from: yaml)
        XCTAssertNoDifference(actual, expected)
    }

    func testDecodeFullGeneratorConfiguration() throws {
        let expected = GeneratorConfiguration(
            indentationStyle: .twoSpaces,
            targetConfigurationName: "foo.yml")

        let yaml = """
            indentationStyle: twoSpaces
            targetConfigurationName: 'foo.yml'
            """

        let actual = try decode(GeneratorConfiguration.self, from: yaml)
        XCTAssertNoDifference(actual, expected)
    }
}

// MARK: - TargetConfiguration
extension ConfigurationTests {
    func testDecodeMinimalTargetConfiguration() throws {
        let expected = TargetConfiguration()

        let yaml = """
        name: ~
        """

        let actual = try decode(TargetConfiguration.self, from: yaml)
        XCTAssertNoDifference(actual, expected)
    }

    func testDecodeFullTargetConfiguration() throws {
        let expected = TargetConfiguration(
            name: "MyTarget",
            dependencies: [
                DependencyConfiguration(name: "Target"),
                DependencyConfiguration(name: "ProductName", type: .product, package: "ProductPackage"),
                DependencyConfiguration(name: "ByName", type: .byName)
            ],
            path: "path/to/target",
            exclude: [
                "this",
                "that"
            ],
            sources: [
                "path/to/source",
                "path/to/another/source"
            ],
            resources: [
                ResourceConfiguration(rule: .copy, path: "path/to/resource"),
                ResourceConfiguration(rule: .process, path: "path/to/other/resource", localization: .base)
            ],
            packageAccess: false,
            plugins: [
                PluginUsageConfiguration(name: "PluginName", package: "PluginPackage"),
                PluginUsageConfiguration(name: "OtherPlugin")
            ]
        )

        let yaml = """
        name: MyTarget
        dependencies:
          - Target
          - name: ProductName
            package: ProductPackage
          - name: ByName
            type: byName
        path: path/to/target
        exclude:
          - this
          - that
        sources:
          - path/to/source
          - path/to/another/source
        resources:
          - path: path/to/resource
            rule: copy
          - path: path/to/other/resource
            rule: process
            localization: base
        packageAccess: false
        plugins:
          - name: PluginName
            package: PluginPackage
          - name: OtherPlugin
        """

        let actual = try decode(TargetConfiguration.self, from: yaml)
        XCTAssertNoDifference(actual, expected)
    }
}

// MARK: - SourceConfiguration
extension ConfigurationTests {
    func testDecodeMinimalSourceConfiguration() throws {
        let expected = SourceConfiguration(type: .regular)

        let yaml = """
            products: ~
            """

        let actual = try decode(SourceConfiguration.self, from: yaml)
        XCTAssertNoDifference(actual, expected)
    }

    func testDecodeFullSourceConfiguration() throws {
        let expected = SourceConfiguration(
            type: .executable,
            products: [
                SourceConfiguration.Product(
                    type: .executable,
                    name: "Executable",
                    targets: [
                        "Target1",
                        "Target2"
                    ]
                ),
                SourceConfiguration.Product(
                    type: .dynamicLibrary,
                    name: "DynamicLibrary",
                    targets: [
                        "Target3",
                        "Target4"
                    ]
                )
            ]
        )

        let yaml = """
        type: executable
        products:
          - name: Executable
            type: executable
            targets:
              - Target1
              - Target2
          - type: dynamicLibrary
            name: DynamicLibrary
            targets:
              - Target3
              - Target4
        """

        let actual = try decode(SourceConfiguration.self, from: yaml)
        XCTAssertNoDifference(actual, expected)
    }
}
