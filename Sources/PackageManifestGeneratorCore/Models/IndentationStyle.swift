//
//  IndentationStyle.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 1/24/24.
//

import Foundation

/// Styles of indentation for generated source code.
public enum IndentationStyle: String, Codable, CodableDefaultSource, Equatable, Sendable {
    /// A style of indentation using two spaces.
    case twoSpaces
    /// A style of indentation using four spaces.
    case fourSpaces
    /// A style of indentation using tabs.
    case tabs

    /// The text specified by the indentation style.
    var source: String {
        switch self {
        case .twoSpaces: "  "
        case .fourSpaces: "    "
        case .tabs: "\t"
        }
    }

    public static var `default`: Self {
        .fourSpaces
    }
}
