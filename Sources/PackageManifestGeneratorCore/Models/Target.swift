//
//  Target.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/16/23.
//

import Foundation

struct Target: Codable, Equatable {
    /// The target name.
    let name: String

    /// The target configuration.
    let configuration: TargetConfiguration
}
