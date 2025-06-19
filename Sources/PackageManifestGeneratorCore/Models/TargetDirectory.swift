//
//  TargetDirectory.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 1/31/24.
//

import Foundation

/// The default locations of different kinds of Swift package targets.
enum TargetDirectory: String, Equatable, Sendable {
    /// The default directory for regular and executable targets.
    case sources = "Sources"
    /// The defaut directory for test targets.
    case tests = "Tests"
    /// The default directory for plugin targets.
    case plugins = "Plugins"

    /// The path of the directory relative to the package root.
    var path: String {
        "/\(rawValue)"
    }
}
