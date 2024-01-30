//
//  Product.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 1/30/24.
//

import Foundation

/// A Swift package product.
struct Product: Equatable {
    
    enum ProductType: Codable, Equatable {
        case executable
        case library
        case dynamicLibrary
        case staticLibrary
        case plugin
    }

    let name: String
    let type: ProductType
    let targets: [String]
}
