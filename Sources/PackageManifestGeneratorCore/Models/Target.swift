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
        /// The name of the plug-in target.
        let name: String

        /// The name of the package defining the plug-in target.
        let package: String?
    }

    /// A resource to bundle with the Swift package.
    struct Resource: Equatable {

        /// The different types of localization for resources.
        public enum Localization: String, Codable, Equatable {
            /// The default localization.
            case base
            /// The base internationalization.
            case `default`
        }

        /// The different rules for resources.
        enum Rule: Equatable {
            case copy
            case embedInCode
            case process(_ localization: Localization?)
        }

        /// The rule for the resource.
        let rule: Rule

        /// The path of the resource.
        let path: String
    }

    /// The different types of a target.
    enum TargetType: String {
        /// A target that contains code for the Swift package's functionality.
        case regular = "target"
        /// A target that contains code for an executable's main module.
        case executable = "executableTarget"
        /// A target that contains tests for the Swift package's other targets.
        case test = "testTarget"
    }

    /// The different types of a target's dependency on another entity.
    enum Dependency: Equatable {
        /// A dependency on a target.
        case targetItem(name: String)
        /// A dependency on a product.
        case productItem(name: String, package: String?)
        /// A by-name dependency on either a target or a product.
        case byNameItem(name: String)
    }

    /// The name of the target.
    let name: String

    /// The type of the target.
    let type: TargetType

    /// A Boolean value determining whether access to package declarations from other targets in
    /// the package is allowed.
    let packageAccess: Bool

    /// The path of the target, relative to the package root.
    let path: String?

    /// The source files in this target.
    let sources: [String]?

    /// The explicit list of resource files in the target.
    let resources: [Resource]?

    /// The paths to source and resource files excluded from the target.
    let exclude: [String]?

    /// The target's dependencies on other entities inside or outside the package.
    var dependencies: [Dependency]?

    /// The plug-ins used by by the target.
    let plugins: [PluginUsage]?

    /// Creates an instance.
    ///
    /// - Parameters:
    ///   - name: The name of the target.
    ///   - type: The type of the target.
    ///   - packageAccess: Whether access to package declarations from other targets in the package
    ///   is allowed.
    ///   - path: The path of the target, relative to the package root.
    ///   - sources: The source files in this target.
    ///   - resources: The explicit list of resource files in the target.
    ///   - exclude: The paths to source and resource files excluded from the target.
    ///   - dependencies: The target's dependencies on other entities inside or outside the package.
    ///   - plugins: The plug-ins used by by the target.
    init(
        name: String,
        type: Target.TargetType = .regular,
        packageAccess: Bool = true,
        path: String? = nil,
        sources: [String]? = nil,
        resources: [Target.Resource]? = nil,
        exclude: [String]? = nil,
        dependencies: [Target.Dependency]? = nil,
        plugins: [Target.PluginUsage]? = nil
    ) {
        self.name = name
        self.type = type
        self.packageAccess = packageAccess
        self.path = path
        self.sources = sources
        self.resources = resources
        self.exclude = exclude
        self.dependencies = dependencies
        self.plugins = plugins
    }
}
