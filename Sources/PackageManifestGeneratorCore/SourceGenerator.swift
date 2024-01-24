//
//  SourceGenerator.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/16/23.
//

import Foundation

/// Generates product and target declarations for the given target configurations.
struct SourceGenerator {
    /// The style of indentation used in the generated code.
    let indentationStyle: IndentationStyle

    /// Creates an instance.
    ///
    /// - Parameter indentationStyle: The style of indentation for the generated source.
    init(indentationStyle: IndentationStyle = .default) {
        self.indentationStyle = indentationStyle
    }

    /// Returns the product and target declarations for the given target configurations.
    ///
    /// - Parameter configurations: The target configurations.
    /// - Returns: The generated product and target declarations.
    func callAsFunction(_ configurations: [Target]) -> String {
        ""
    }
}
