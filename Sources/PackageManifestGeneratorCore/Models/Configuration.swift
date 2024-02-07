//
//  Configuration.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 1/28/24.
//

import Foundation

/// A wrapper for a configuration and data about its location.
struct Configuration<C: Equatable>: Equatable {
    /// The target directory in which a configuration file is located.
    let targetDirectory: TargetDirectory

    /// The name of the directory in which a configuration file is located.
    let directoryName: String

    /// The name of the configuration file.
    let fileName: String

    /// The configuration.
    let configuration: C

    /// The path of the configuration file relative to the package root.
    var path: String {
        "\(targetDirectory.path)/\(directoryName)/\(fileName)"
    }
}
