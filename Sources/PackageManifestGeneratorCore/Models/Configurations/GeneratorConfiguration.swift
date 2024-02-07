//
//  GeneratorConfiguration.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/16/23.
//

import Foundation

/// The configuration for ``PackageManifestGenerator``.
public struct GeneratorConfiguration: Codable, Equatable {
    public enum TargetConfigurationName: CodableDefaultSource {
        public static var `default` = "_config.yml"
    }

    /// The indentation style of the generated code.
    @CodableDefault<IndentationStyle> public var indentationStyle: IndentationStyle

    /// The name of target configuration files.
    @CodableDefault<TargetConfigurationName> public var targetConfigurationName: String

    /// Creates a new configuration.
    ///
    /// - Parameters:
    ///   - indentationStyle: The indentation style used when the generating code.
    ///   - targetConfigurationName: The name of target configuration files.
    public init(
        indentationStyle: IndentationStyle = .default,
        targetConfigurationName: String = TargetConfigurationName.default
    ) {
        self.indentationStyle = indentationStyle
        self.targetConfigurationName = targetConfigurationName
    }
}
