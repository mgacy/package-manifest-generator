//
//  Target.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/16/23.
//

import Foundation

/// A Swift package target.
struct Target: Equatable {

    /// A plug-in used in a target.
    struct PluginUsage: Equatable {
        let name: String
        let package: String?
    }

    /// A resource to bundle with the Swift package.
    struct Resource: Equatable {

        enum Rule: Equatable {
            case copy
            case embedInCode
            case process(_ localization: String?)
        }

        let rule: Rule
        let path: String
    }

    /// The different types of a target.
    enum TargetType: String {
        case regular = "target"
        case executable = "executableTarget"
        case test = "testTarget"
    }

    /// The different types of a target's dependency on another entity.
    public enum Dependency: Equatable {
        case targetItem(name: String)
        case productItem(name: String, package: String?)
        case byNameItem(name: String)
    }

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
