//
//  GeneratorConfiguration.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/16/23.
//

import Foundation

/// The configuration for ``PackageManifestGenerator``.
public struct GeneratorConfiguration: Codable, Equatable {
    public enum DefaultTargetConfigurationName: CodableDefaultSource {
        public static var `default` = "_config.yml"
    }

    /// The indentation style of the generated code.
    @CodableDefault<IndentationStyle> public var indentationStyle: IndentationStyle

    /// The name of target configuration files.
    @CodableDefault<DefaultTargetConfigurationName> public var targetConfigurationName: String

    /// Creates a new configuration.
    ///
    /// - Parameters:
    ///   - indentationStyle: The indentation style used when the generating code.
    ///   - targetConfigurationName: The name of target configuration files.
    public init(
        indentationStyle: IndentationStyle = .default,
        targetConfigurationName: String = "_config.yml"
    ) {
        self.indentationStyle = indentationStyle
        self.targetConfigurationName = targetConfigurationName
    }
}
