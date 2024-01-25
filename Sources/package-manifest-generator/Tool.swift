//
//  Tool.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/13/23.
//

import ArgumentParser
import PackageManifestGeneratorCore

@main
struct Tool: AsyncParsableCommand {
    mutating func run() async throws {
        try await PackageManifestGenerator.run(packagePath: "")
    }
}
