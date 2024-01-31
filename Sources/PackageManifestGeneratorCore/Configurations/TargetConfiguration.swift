//
//  TargetConfiguration.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/19/23.
//

import Foundation

/// The configuration for a package target.
public struct TargetConfiguration: Codable, Equatable {

    public struct ProductDependency: Codable, Equatable {
        public let name: String
        public let package: String
    }

    public struct Dependencies: Codable, Equatable {
        public let targets: [String]?
        public let products: [ProductDependency]?
    }

    public struct Plugin: Codable, Equatable {
        public let name: String
        public let package: String?
    }

    public enum ResourceRule: String, Codable, CodableDefaultSource, Equatable {
        case copy
        case embed
        case process

        public static var `default`: Self {
            .process
        }
    }
    public enum ResourceLocalization: String, Codable, Equatable {
        case base
        case `default`
    }

    public struct Resource: Codable, Equatable {
        @CodableDefault<ResourceRule> public var rule: ResourceRule
        public let path: String
        public let localization: ResourceLocalization?
    }

    public let name: String?
    public let dependencies: Dependencies?
    public let path: String?
    public let exclude: [String]?
    public let sources: [String]?
    public let resources: [Resource]?
    public let packageAccess: Bool?
    public let plugins: [Plugin]?
}
