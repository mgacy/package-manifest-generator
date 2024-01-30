//
//  SourceConfiguration.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 1/30/24.
//

import Foundation

/// The configuration for a regular or executable target and associated products.
public struct SourceConfiguration: Codable, Equatable {

    public enum ProductType: String, Codable, CodableDefaultSource, Equatable {
        case executable
        case library
        case dynamicLibrary = "dynamic"
        case staticLibrary = "static"

        public static var `default`: ProductType {
            .library
        }
    }

    public struct Product: Codable, Equatable {
        @CodableDefault<ProductType> public var type: ProductType
        public let name: String?
        public let targets: [String]?
    }

    public enum TargetType: String, Codable, CodableDefaultSource, Equatable {
        case regular
        case executable

        public static var `default`: TargetType {
            .regular
        }
    }

    @CodableDefault<TargetType> public var type: TargetType

    public let target: TargetConfiguration?

    public let products: [Product]?
}
