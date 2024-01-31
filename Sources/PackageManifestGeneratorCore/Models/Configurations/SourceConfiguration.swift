//
//  SourceConfiguration.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 1/30/24.
//

import Foundation

/// The configuration for a regular or executable target and associated products.
public struct SourceConfiguration: Codable, Equatable {

    /// The different types of a target.
    public enum ProductType: String, Codable, CodableDefaultSource, Equatable {
        /// An executable product.
        case executable
        /// A library product.
        case library
        /// A dynamically-linked library product.
        case dynamicLibrary = "dynamic"
        /// A statically-linked library product.
        case staticLibrary = "static"

        public static var `default`: ProductType {
            .library
        }
    }

    public struct Product: Codable, Equatable {
        // TODO: how does having a default work with name, target being optional?
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

    /// The type of the target.
    @CodableDefault<TargetType> public var type: TargetType

    /// The target configuration.
    public let target: TargetConfiguration?

    /// The products associated with the target.
    public let products: [Product]?

    /// Creates an instance.
    ///
    /// - Parameters:
    ///   - type: The target type.
    ///   - target: The target configuration.
    ///   - products: Products associated with the target.
    public init(
        type: SourceConfiguration.TargetType,
        target: TargetConfiguration? = nil,
        products: [SourceConfiguration.Product]? = nil
    ) {
        self.type = type
        self.target = target
        self.products = products
    }
}
