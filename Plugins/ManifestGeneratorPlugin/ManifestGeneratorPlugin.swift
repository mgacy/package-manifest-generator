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
        // ...
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension ManifestGeneratorPlugin: XcodeCommandPlugin {
    /// Invoked by Xcode to perform the custom actions of the command.
    ///
    /// - Parameters:
    ///   - context: The Xcode plug-in context.
    ///   - arguments: The command arguments.
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        /// ...
    }
}
#endif
