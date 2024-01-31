//
//  SourceModelBuilder.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 1/30/24.
//

import Foundation

struct SourceModelBuilder {
    func callAsFunction(
        sources: [Directory<SourceConfiguration>]?,
        tests: [Directory<TestConfiguration>]?
    ) throws -> ([Target], [Product]?)? {
        var products: [Product] = []
        var targets: [Target] = []
        return (targets, products.isEmpty ? nil : products)
    }
}
