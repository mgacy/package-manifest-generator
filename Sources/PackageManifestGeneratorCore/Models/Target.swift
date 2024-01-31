//
//  Target.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/16/23.
//

import Foundation

/// A Swift package target.
struct Target: Equatable {

    struct PluginUsage: Equatable {
        let name: String
        let package: String?
    }
    struct Resource: Equatable {

        enum Rule: Equatable {
            case copy
            case embedInCode
            case process(_ localization: String?)
        }

        let rule: Rule
        let path: String
    }

    enum TargetType: String {
        case regular = "target"
        case executable = "executableTarget"
        case test = "testTarget"
    }

    public enum Dependency: Equatable {
        case targetItem(name: String)
        case productItem(name: String, package: String?)
        case byNameItem(name: String)
    }

    /// The name of the target.
    let name: String
    let type: TargetType
    let packageAccess: Bool
    let path: String?
    let sources: [String]?
    let resources: [Resource]?
    let exclude: [String]?
    var dependencies: [Dependency]?
    let plugins: [PluginUsage]?
}
