//
//  Tool.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/13/23.
//

import ArgumentParser
import PackageManifestGeneratorCore

/// The main entry point for `package-manifest-generator`.
@main
struct Tool: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Generate Swift package manifest products and targets from configuration files.",
        version: Version.number)

    /// Runs the tool.
    mutating func run() async throws {
        try await PackageManifestGenerator.run(packagePath: "")
    }
}
