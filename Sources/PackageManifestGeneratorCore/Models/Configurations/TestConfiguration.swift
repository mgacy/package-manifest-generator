//
//  TestConfiguration.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 1/30/24.
//

import Foundation

/// The configuration for a test target.
public struct TestConfiguration: Codable, Equatable {
    public let target: TargetConfiguration?
}


