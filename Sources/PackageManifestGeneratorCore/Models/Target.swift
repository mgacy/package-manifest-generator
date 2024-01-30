//
//  Target.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/16/23.
//

import Foundation

/// A Swift package target.
struct Target: Equatable {

    struct Resource: Equatable {

        enum Rule: Equatable {
            case copy
            case process(_ localization: String?)
        }

        let rule: Rule
        let path: String
    }

    enum TargetType: String {
        case regular
        case executable
        case test
    }

    struct PluginUsage: Equatable {
        let name: String
        let package: String?
    }

    public enum Dependency: Equatable {
    }

    /// The name of the target.
    let name: String

    let path: String?
    let sources: [String]?
    let resources: [Resource]?
    let exclude: [String]
    let dependencies: [Dependency]
    let type: TargetType
    let packageAccess: Bool
    let plugins: [PluginUsage]?
}
