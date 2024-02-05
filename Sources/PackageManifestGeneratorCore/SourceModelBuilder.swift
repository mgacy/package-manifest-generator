//
//  SourceModelBuilder.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 1/30/24.
//

import Foundation

/// A builder to validate configuration files and generate the source models they represent.
struct SourceModelBuilder {
    /// Returns products and targets specified by the given configurations.
    ///
    /// - Parameters:
    ///   - sources: The source target configurations.
    ///   - tests: The test target configurations.
    /// - Returns: The products and targets specified by the given configurations.
    func callAsFunction(
        sources: [Configuration<SourceConfiguration>]?,
        tests: [Configuration<TestConfiguration>]?
    ) throws -> ([Target], [Product]?)? {
        guard sources != nil || tests != nil else {
            return nil
        }

        var products: [Product] = []
        var targets: [Target] = []

        // Sources
        if let sources {
            for source in sources {
                do {
                    let targetType: Target.TargetType = switch source.configuration.type {
                    case .executable: .executable
                    case .regular: .regular
                    }

                    let target = try makeTarget(
                        directoryName: source.directoryName,
                        targetType: targetType,
                        configuration: source.configuration.target)
                    targets.append(target)

                    if let productConfigs = source.configuration.products {
                        for productConfig in productConfigs {
                            products.append(makeProduct(productConfig, targetName: target.name))
                        }
                    }
                } catch {
                    throw "Invalid configuration at `\(source.path)"
                }
            }
        }

        // Tests
        if let tests {
            for test in tests {
                do {
                    targets.append(try makeTarget(
                        directoryName: test.directoryName,
                        targetType: .test,
                        configuration: test.configuration.target))
                } catch {
                    throw "Invalid configuration at `\(test.path)"
                }
            }
        }

        return (targets, products.isEmpty ? nil : products)
    }
}

extension SourceModelBuilder {
    func makeDependency(_ configuration: DependencyConfiguration) throws -> Target.Dependency {
        switch configuration.type {
        case .target:
                .targetItem(name: configuration.name)
        case .product:
            .productItem(name: configuration.name, package: configuration.package)
        case .byName:
            .byNameItem(name: configuration.name)
        }
    }

    func makeResource(_ resource: ResourceConfiguration) throws -> Target.Resource {
        if !resource.isProcess && resource.localization != nil {
            throw "Invalid Configuration"
        }

        let localization: Target.Resource.Localization? = resource.localization.flatMap {
            switch $0 {
            case .base: .base
            case .default: .default
            }
        }
        let rule: Target.Resource.Rule = switch resource.rule {
        case .copy: .copy
        case .embed: .embedInCode
        case .process: .process(localization)
        }

        return Target.Resource(rule: rule, path: resource.path)
    }

    func makeTarget(
        directoryName: String,
        targetType: Target.TargetType = .regular,
        configuration: TargetConfiguration? = nil
    ) throws -> Target {
        let dependencies = try configuration?.dependencies?.map(makeDependency(_:))
        let resources = try configuration?.resources?.map(makeResource(_:))
        let plugins = configuration?.plugins?.map { Target.PluginUsage(name: $0.name, package: $0.package) }

        return Target(
            name: configuration?.name ?? directoryName,
            type: targetType,
            packageAccess: configuration?.packageAccess ?? true,
            path: configuration?.path,
            sources: configuration?.sources,
            resources: resources,
            exclude: configuration?.exclude,
            dependencies: dependencies,
            plugins: plugins)
    }

    func makeProduct(_ product: SourceConfiguration.Product, targetName: String) -> Product {
        let productType: Product.ProductType = switch product.type {
        case .executable: .executable
        case .library: .library(nil)
        case .dynamicLibrary: .library(.dynamic)
        case .staticLibrary: .library(.static)
        }

        return Product(
            name: product.name ?? targetName,
            type: productType,
            targets: product.targets ?? [targetName])
    }
}
