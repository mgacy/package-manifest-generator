//
//  ManifestGeneratorPlugin.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 2/1/24.
//

import Foundation
import PackagePlugin

@main
struct ManifestGeneratorPlugin: CommandPlugin {
    /// Invoked by SwiftPM to perform the custom actions of the command.
    ///
    /// - Parameters:
    ///   - context: The plug-in context.
    ///   - arguments: The command arguments.
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let generator = try context.tool(named: "package-manifest-generator").path

        let packagePath = context.package.directory
        var generatorArgs = [
            "--package-path", packagePath.string
        ]

        var argExtractor = ArgumentExtractor(arguments)
        if let configFile = argExtractor.extractOption(named: "config").first {
            generatorArgs.append(contentsOf: ["--config", configFile])
        }

        try generator.exec(arguments: generatorArgs)
    }
}
