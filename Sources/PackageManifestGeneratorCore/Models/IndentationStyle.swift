//
//  IndentationStyle.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 1/24/24.
//

import Foundation

/// Styles of indentation for generated source code.
public enum IndentationStyle: String, Codable, CodableDefaultSource, Equatable {
    /// A style of indentation using two spaces.
    case twoSpaces
    /// A style of indentation using four spaces.
    case fourSpaces
    /// A style of indentation using tabs.
    case tabs

    public static var `default`: Self {
        .fourSpaces
    }
}
