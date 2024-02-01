//
//  Tool.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/13/23.
//

import ArgumentParser
import Foundation
import PackageManifestGeneratorCore

/// The main entry point for `package-manifest-generator`.
@main
struct Tool: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "package-manifest-generator",
        abstract: "Generate Swift package manifest products and targets from configuration files.",
        version: Version.number)

    @Option(name: .customLong("config"),
            help: "The path to the generator configuration file.",
            completion: .file())
    var configurationPath: String?

    @Option(help: "The package path to operate on (default current directory).", 
            completion: .directory)
    var packagePath: String?

    /// Runs the tool.
    mutating func run() async throws {
        try await PackageManifestGenerator.run(
            packagePath: packagePath ?? FileManager.default.currentDirectoryPath,
            configurationPath: configurationPath)
    }
}
