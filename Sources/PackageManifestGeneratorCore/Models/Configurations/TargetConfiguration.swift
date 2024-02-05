//
//  TargetConfiguration.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/19/23.
//

import Foundation

/// The configuration for a package target dependency.
public struct DependencyConfiguration: Codable, Equatable {

    /// The different types of a dependency.
    public enum DependencyType: String, Codable, Equatable {
        /// A dependency on a target.
        case target
        /// A dependency on a product.
        case product
        /// A by-name dependency on either a target or a product.
        case byName
    }

    /// The name of the target.
    let name: String

    /// The type of the dependency.
    let type: DependencyType

    /// The name of the package for a product dependency.
    let package: String?

    /// Creates an instance.
    ///
    /// - Parameters:
    ///   - name: The name of the target or product.
    ///   - type: The type of the dependency.
    ///   - package: The package for a product dependency.
    public init(name: String, type: DependencyType = .target, package: String? = nil) {
        self.name = name
        self.type = type
        self.package = package
    }

    public init(from decoder: Decoder) throws {
        let literalContainer = try decoder.singleValueContainer()
        if let literal = try? literalContainer.decode(String.self) {
            // Allow specifying a target dependency by a simple string
            self.name = literal
            self.type = .target
            self.package = nil
        } else {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

            self.name = try container.decode(String.self, forKey: .name)
            let package = try container.decodeIfPresent(String.self, forKey: .package)
            self.package = package

            let type = try container.decodeIfPresent(DependencyType.self, forKey: .type)
            if let type {
                self.type = type
            } else {
                // If no type is specified, use `DependencyType.product` if a package is given, 
                // otherwise `DependencyType.target`
                self.type = package == nil ? .target : .product
            }
        }
    }
}

extension DependencyConfiguration: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.name = value
        self.type = .target
        self.package = nil
    }
}

/// The configuration for a plugin used by a package target.
public struct PluginUsageConfiguration: Codable, Equatable {
    /// The name of the plug-in target.
    public let name: String

    /// The name of the package defining the plug-in target.
    public let package: String?

    /// Creates an instance.
    ///
    /// - Parameters:
    ///   - name: The plug-in target name.
    ///   - package: The package defining the plug-in target.
    public init(name: String, package: String? = nil) {
        self.name = name
        self.package = package
    }
}

/// The configuration for a resource used by a package target.
public struct ResourceConfiguration: Codable, Equatable {

    /// The different rules for resources.
    public enum Rule: String, Codable, CodableDefaultSource, Equatable {
        case copy
        case embed
        case process

        public static var `default`: Self {
            .process
        }
    }

    /// The different types of localization for resources.
    public enum Localization: String, Codable, Equatable {
        /// The default localization.
        case base
        /// The base internationalization.
        case `default`
    }

    /// The rule for the resource.
    @CodableDefault<Rule> public var rule: Rule
    
    /// The path of the resource.
    public let path: String

    /// The localization for the resource.
    ///
    /// - Warning: this is only valid for resources with a type of ``ResourceConfiguration/Rule-swift.enum/process``; an
    /// error will be thrown if a value is provided for a resource with a different rule.
    public let localization: Localization?

    /// A Boolean value indicating whether the resource has a process rule.
    var isProcess: Bool {
        self.rule == .process
    }

    /// Creates an instance.
    ///
    /// - Parameters:
    ///   - rule: The rule for the resource.
    ///   - path: The path of the resource.
    ///   - localization: The localization for the resource.
    public init(rule: Rule, path: String, localization: Localization? = nil) {
        self.rule = rule
        self.path = path
        self.localization = localization
    }
}

/// The configuration for a package target.
public struct TargetConfiguration: Codable, Equatable {

    /// The name of the target.
    public let name: String?

    /// The target's dependencies on other entities inside or outside the package.
    public let dependencies: [DependencyConfiguration]?

    /// The path of the target, relative to the package root.
    public let path: String?

    /// The paths to source and resource files excluded from the target.
    public let exclude: [String]?
    
    /// The source files in this target.
    public let sources: [String]?
    
    /// The explicit list of resource files in the target.
    public let resources: [ResourceConfiguration]?
    
    /// A Boolean value determining whether access to package declarations from other targets in
    /// the package is allowed.
    public let packageAccess: Bool?
    
    /// The plug-ins used by by the target.
    public let plugins: [PluginUsageConfiguration]?

    /// Creates an instance.
    ///
    /// - Parameters:
    ///   - name: The name of the target.
    ///   - dependencies: The target's dependencies.
    ///   - path: The path of the target.
    ///   - exclude: Paths to files excluded from the target.
    ///   - sources: The source files in the target.
    ///   - resources: Resource files in the target.
    ///   - packageAccess: Whether access to package declarations from other targets is allowed.
    ///   - plugins: Plug-ins used by the target.
    public init(
        name: String? = nil,
        dependencies: [DependencyConfiguration]? = nil,
        path: String? = nil,
        exclude: [String]? = nil,
        sources: [String]? = nil,
        resources: [ResourceConfiguration]? = nil,
        packageAccess: Bool? = nil,
        plugins: [PluginUsageConfiguration]? = nil
    ) {
        self.name = name
        self.dependencies = dependencies
        self.path = path
        self.exclude = exclude
        self.sources = sources
        self.resources = resources
        self.packageAccess = packageAccess
        self.plugins = plugins
    }
}
