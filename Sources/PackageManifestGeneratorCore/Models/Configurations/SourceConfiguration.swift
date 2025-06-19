//
//  SourceConfiguration.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 1/30/24.
//

import Foundation

/// The configuration for a regular or executable target and associated products.
public struct SourceConfiguration: Codable, Equatable, Sendable {

    /// The different types of products.
    public enum ProductType: String, Codable, CodableDefaultSource, Equatable, Sendable {
        /// An executable product.
        case executable
        /// A library product.
        case library
        /// A dynamically-linked library product.
        case dynamicLibrary
        /// A statically-linked library product.
        case staticLibrary

        public static var `default`: ProductType {
            .library
        }
    }

    /// The configuration for a product.
    public struct Product: Codable, Equatable, Sendable {
        /// The type of product.
        @CodableDefault<ProductType> public var type: ProductType

        /// The name of the product.
        public let name: String?

        /// The names of targets in this product.
        public let targets: [String]?

        /// Creates an instance.
        ///
        /// - Parameters:
        ///   - type: The type of product.
        ///   - name: The name of the product.
        ///   - targets: The names of targets in the product.
        public init(
            type: SourceConfiguration.ProductType,
            name: String? = nil,
            targets: [String]? = nil
        ) {
            self.type = type
            self.name = name
            self.targets = targets
        }
    }

    /// The different types of targets.
    public enum TargetType: String, Codable, CodableDefaultSource, Equatable, Sendable {
        /// A regular target.
        case regular
        /// An executable target.
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
