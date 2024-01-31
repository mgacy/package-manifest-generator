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
    enum DependencyType: String, Codable, Equatable {
        case target
        case product
        case byName
    }

    let name: String
    let type: DependencyType
    let package: String?

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
    public let name: String
    public let package: String?
}

/// The configuration for a resource used by a package target.
public struct ResourceConfiguration: Codable, Equatable {
    
    public enum Rule: String, Codable, CodableDefaultSource, Equatable {
        case copy
        case embed
        case process

        public static var `default`: Self {
            .process
        }
    }

    public enum Localization: String, Codable, Equatable {
        case base
        case `default`
    }

    @CodableDefault<Rule> public var rule: Rule
    public let path: String
    public let localization: Localization?

    var isProcess: Bool {
        self.rule == .process
    }
}

/// The configuration for a package target.
public struct TargetConfiguration: Codable, Equatable {
    public let name: String?
    public let dependencies: [DependencyConfiguration]?
    public let path: String?
    public let exclude: [String]?
    public let sources: [String]?
    public let resources: [ResourceConfiguration]?
    public let packageAccess: Bool?
    public let plugins: [PluginUsageConfiguration]?
}
