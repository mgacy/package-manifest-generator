//
//  PackageManifestGenerator.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/13/23.
//

import Files
import Foundation
import Yams

/// The main entry point for PackageManifestGeneratorCore.
public struct PackageManifestGenerator {
    /// Runs the generator.
    ///
    /// - Parameters:
    ///   - packagePath: The path to the package root.
    ///   - configuration: The generator configuration.
    public static func run(packagePath: String, configuration config: GeneratorConfiguration) async throws {
        let packageRoot = try Folder(path: packagePath)
        let packageManifest = try packageRoot.file(named: "Package.swift")
        let (prefix, suffix) = try ManifestHandler.components(of: packageManifest.readAsString())

        let decoder = YAMLDecoder()
        var targets: [Target] = []

        // Sources
        let sourceConfigs = try packageRoot
            .subfolder(named: "Sources")
            .processFilesInSubfolders(named: config.targetConfigurationName) { folder, data in
                try data.flatMap {
                    Target(
                        name: folder.name,
                        configuration: try decoder.decode(TargetConfiguration.self, from: $0))
                }
            }
        if let sourceConfigs {
            targets.append(contentsOf: sourceConfigs)
        }

        // Tests
        let tests = try? packageRoot.subfolder(named: "Tests")
        let testConfigs = try tests?.processFilesInSubfolders(named: config.targetConfigurationName) { folder, data in
            try data.flatMap {
                Target(
                    name: folder.name,
                    configuration: try decoder.decode(TargetConfiguration.self, from: $0))
            }
        }
        if let testConfigs {
            targets.append(contentsOf: testConfigs)
        }

        // Update manifest
        let generated = SourceGenerator(indentationStyle: config.indentationStyle)(targets)
        let updatedManifest = ManifestHandler.assemble(
            prefix: prefix,
            generated: generated,
            suffix: suffix)
        try packageManifest.write(updatedManifest, encoding: .utf8)
    }
}

public extension PackageManifestGenerator {
    /// Runs the generator.
    ///
    /// - Parameters:
    ///   - packagePath: The path to the package root.
    ///   - configurationPath: The path to the generator configuration file.
    static func run(packagePath: String, configurationPath: String? = nil) async throws {
        let configuration = try configurationPath.flatMap { path in
            try YAMLDecoder().decode(GeneratorConfiguration.self, from: try File(path: path).read())
        } ?? GeneratorConfiguration()

        try await run(packagePath: packagePath, configuration: configuration)
    }
}
