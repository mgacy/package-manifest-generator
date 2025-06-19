//
//  Product.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 1/30/24.
//

import Foundation

/// A Swift package product.
struct Product: Equatable, Sendable {

    /// The different types of a library product.
    enum LibraryType: String, Equatable, Sendable {
        /// A dynamically-linked library.
        case dynamic
        /// A statically-linked library.
        case `static`
    }

    enum ProductType: Equatable, Sendable {
        /// An executable product.
        case executable
        /// A library product.
        case library(_ type: LibraryType?)
        /// A plugin product.
        case plugin
    }

    /// The name of the package product.
    let name: String

    /// The type of product.
    let type: ProductType

    /// The names of the targets in this product.
    let targets: [String]
}
