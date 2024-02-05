//
//  TestConfiguration.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 1/30/24.
//

import Foundation

/// The configuration for a test target.
public struct TestConfiguration: Codable, Equatable {

    /// The target configuration.
    public let target: TargetConfiguration?

    /// Creates an instance.
    ///
    /// - Parameter target: The target configuration.
    public init(target: TargetConfiguration? = nil) {
        self.target = target
    }
}
