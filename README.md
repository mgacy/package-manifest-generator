# package-manifest-generator

Define SwiftPM products and targets with YAML configuration files.

## 🎯 Use Case

Maintaining the manifest of a Swift package with many targets -- for example, a `Features` package with a target for each feature of an application -- can become unwieldy. This tool is designed to address that by using YAML configuration files in each target to generate package product and target declarations that it inserts into a package manifest. These configuration files can also be added as part of any automations used to bootstrap new feature creation.

## 🖥 Installation

Package Manifest Generator may be used either as a standalone CLI tool or as a Swift Package Manager plugin.

### Executable

You can use [Mint](https://github.com/yonaskolb/mint) to install `package-manifest-generator`:

```sh
$ mint install Mobelux/package-manifest-generator
```

Alternatively, you can use the [Makefile](Makefile) to build and install:

```sh
$ make install
```

### SwiftPM Command Plugin

To use Package Manifest Generator as a SwiftPM plugin, simply add it as a package dependency; there is no need to add it to any target dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/Mobelux/package-manifest-generator.git", from: "0.1.0")
    ...
]
```

Invoke the command plugin with:

```sh
$ swift package generate-manifest --allow-writing-to-package-directory
```

## ⚙ Usage

### Tool Configuration

Configure Package Manifest Generator by adding a `.packagemanifestgenerator.yml` file to the package root:

```yaml
# Control the indentation style of the generated code. Valid options are `twoSpaces`, `fourSpaces` (default), and `tabs`.
indentationStyle: fourSpaces
# Name of the configuration file at the root of target directories.
targetConfigurationName: '_config.yml'
```

### Target Configuration

Package Manifest Generator expects that all regular and executable targets are located in the default `Sources/` directory and all test targets are located in the default `Tests/` directory. Each target that will be controlled by the generator must have a configuration file at the root of the target's directory. The default name of this file is `_config.yml`, but this can by configured using `targetConfigurationName` in the [tool configuration](#tool-configuration). All target configurations have an optional `target` property representing representing the [`TargetConfiguration`](Sources/PackageManifestGeneratorCore/Models/Configurations/TargetConfiguration.swift) model:

```yaml
# Common target configuration options.
target:
  # The target name. If no value is provided the name of the parent directory will be used.
  name: MyTarget
  # The target dependencies.
  dependencies:
    # Target dependencies can be specified by their name. Other types are defined like below.
    - Basic
      # The dependency name.
    - name: Product
      # The product type. Valid options: `target` | `product` | `byName`
      type: product
      # The dependency package; only valid for the `product` type.
      package: package
      # The path of the target, relative to the package root.
      path: path/to/target
      # The paths to source and resource files excluded from the target.
      exclude:
        - excluded.txt
      # The source files in the target.
      sources:
        - foo.swift
      # The explicit list of resources in the target.
      resources:
          # The path to the resource
        - path: path/to/resource.txt
          # The resource rule. Valid options: `copy` | `embed` | `process` (Default)
          rule: process
          # The localization for the resource; only valid for `process` type. Valid options: `base` | `default`
          localization: base
      # Whether access to package declarations from other targets in the package is allowed. Default: `true`
      packageAccess: true
      # Plug-ins used by the target.
      plugins:
          # The name of the plug-in.
        - name: Plugin
          # The name of the package.
          package: package
```

Regular and executable targets are configured with YAML representations of [`SourceConfiguration`](Sources/PackageManifestGeneratorCore/Models/Configurations/SourceConfiguration.swift):

```yaml
# The type of target. Valid options: `regular` (default) | `executable`
type: regular
# Common target configuration options; see above.
target:
  # ...
# The target products
products:
    # The name of the product.
  - name: ProductName
    # The product type. Valid options: `executable` | `library` (Default) | `dynamicLibrary` | `staticLibrary`
    type: library
    # The product targets.
    targets:
      # The target name.
      - MyTarget
```

Test targets are configured using YAML representations of [`TestConfiguration`](Sources/PackageManifestGeneratorCore/Models/Configurations/TestConfiguration.swift):

```yaml
# Common target configuration options; see above.
target:
  # ...
```
