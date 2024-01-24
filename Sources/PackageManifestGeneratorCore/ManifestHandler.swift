//
//  ManifestHandler.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/19/23.
//

import Foundation

/// A handler to decompose and assemble a generated package manifest.
struct ManifestHandler {
    /// Returns the manually-generated prefix and optional suffix from the given package manifest
    /// contents.
    ///
    /// - Parameter manifest: The contents of a package manifest.
    /// - Returns: A tuple that contains the `Package` instance declaration and optional statements
    /// modifying that instance.
    static func components(of manifest: String) throws -> (String, String?) {
        ("", nil)
    }

    /// Returns the complete package manifest by assembling the given parts.
    ///
    /// - Parameters:
    ///   - prefix: The package declaration.
    ///   - generated: The generated product and target declarations.
    ///   - suffix: Statements modifying the package with the generated declarations.
    /// - Returns: The complete package manifest.
    static func assemble(prefix: String, generated: String, suffix: String? = nil) -> String {
        ""
    }
}
