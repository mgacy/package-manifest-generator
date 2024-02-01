//
//  Extensions.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 2/1/24.
//

import Foundation

/// Easily throw generic errors with a text description.
extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}
