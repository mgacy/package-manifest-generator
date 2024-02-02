//
//  SourceGenerator.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/16/23.
//

import Foundation

/// Generates product and target declarations for the given target configurations.
struct SourceGenerator {
    /// The style of indentation used in the generated code.
    let indentationStyle: IndentationStyle

    /// Creates an instance.
    ///
    /// - Parameter indentationStyle: The style of indentation for the generated source.
    init(indentationStyle: IndentationStyle = .default) {
        self.indentationStyle = indentationStyle
    }

    /// Returns the product and target declarations for the given targets.
    ///
    /// - Parameters:
    ///   - targets: The targets.
    ///   - products: The products
    /// - Returns: The generated product and target declarations.
    func callAsFunction(targets: [Target], products: [Product]?) -> String {
        let productStrings = products?.map(Self.product(_:)) ?? []
        let targetStrings = targets.map(self.target(_:))

        return """
        var \(Constants.generatedProductsName): [Product] = \(productStrings.asSourceArray(indentationStyle: indentationStyle))

        var \(Constants.generatedTargetsName): [Target] = \(targetStrings.asSourceArray(indentationStyle: indentationStyle))
        """
    }
}

extension SourceGenerator {
    static func product(
        _ product: Product
    ) -> String {
        let name = product.name.quoted()
        let targets = "[\(product.targets.map { $0.quoted() }.joined(separator: ", "))]"
        return switch product.type {
        case .executable:
            ".executable(name: \(name), targets: \(targets))"
        case .library(let type):
            ".library(name: \(name)" +
            (type.flatMap { ", type: .\($0.rawValue)" } ?? "") +
            ", targets: \(targets))"
        case .plugin:
            ".plugin(name: \(name), targets: \(targets))"
        }
    }

    static func dependency(_ dependency: Target.Dependency) -> String {
        switch dependency {
        case let .targetItem(name):
            name.quoted()
        case let .productItem(name, package):
            ".product(name: \(name.quoted())" + (package.flatMap { ", package: \($0.quoted())" } ?? "") + ")"
        case let .byNameItem(name):
            ".byName(name: \(name.quoted()))"
        }
    }

    static func resource(_ resource: Target.Resource) -> String {
        let path = resource.path.quoted()
        return switch resource.rule {
        case .copy:
            ".copy(\(path))"
        case .embedInCode:
            ".embedInCode(\(path))"
        case .process(let localization):
            ".process(\(path)" + (localization.flatMap { ", localization: .\($0.rawValue)" } ?? "") + ")"
        }
    }

    static func plugin(_ plugin: Target.PluginUsage) -> String {
        ".plugin(name: \(plugin.name.quoted())"
            + (plugin.package.flatMap { ", package: \($0.quoted())" } ?? "")
            + ")"
    }

    func target(
        _ target: Target
    ) -> String {
        var arguments = ["name: \(target.name.quoted())"]

        // Dependencies
        let dependencies = target.dependencies?.map(Self.dependency(_:))
        if var dependencies, dependencies.isNotEmpty {
            dependencies.sort()
            arguments.append("dependencies: \(dependencies.asSourceArray(indentationStyle: indentationStyle))")
        }

        // Path
        if let path = target.path {
            arguments.append("path: \(path.quoted())")
        }

        // Exclude
        if let exclude = target.exclude, exclude.isNotEmpty {
            arguments.append("exclude: \(exclude.asSourceArray(indentationStyle: indentationStyle))")
        }

        // Sources
        if let sources = target.sources, sources.isNotEmpty {
            arguments.append("sources: \(sources.asSourceArray(indentationStyle: indentationStyle))")
        }

        // Resources
        if let resources = target.resources, resources.isNotEmpty {
            arguments.append("resource: \(resources.map(Self.resource(_:)).asSourceArray(indentationStyle: indentationStyle))")
        }

        // Plugins
        if let plugins = target.plugins, plugins.isNotEmpty {
            arguments.append("plugins: \(plugins.map(Self.plugin(_:)).asSourceArray(indentationStyle: indentationStyle))")
        }

        return """
        .\(target.type.rawValue)(
        \(arguments.joined(separator: ",\n").indented(1, style: indentationStyle))
        )
        """
    }
}
