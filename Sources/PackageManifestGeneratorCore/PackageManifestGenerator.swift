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
    public static func run(packagePath: String, configuration config: Configuration) async throws {

        // ...
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
            try YAMLDecoder().decode(Configuration.self, from: try File(path: path).read())
        } ?? .default

        try await run(packagePath: packagePath, configuration: configuration)
    }
}
