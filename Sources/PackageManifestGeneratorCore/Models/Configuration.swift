//
//  Configuration.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/16/23.
//

import Foundation

/// The configuration for ``PackageManifestGenerator``.
public struct Configuration: Codable, Equatable {
    /// The indentation style of the generated code.
    @CodableDefault<IndentationStyle> public var indentationStyle: IndentationStyle

    /// The name of target configuration files.
    public var targetConfigurationName: String?
}
