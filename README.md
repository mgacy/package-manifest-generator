# package-manifest-generator

Define SwiftPM products and targets with YAML configuration files.

## Use Case

Maintaining the manifest of a Swift package with many targets -- for example, a `Features` package with a target for each feature of an application -- can become unwieldy. This tool is designed to address that by using YAML configuration files in each target to generate package product and target declarations that it inserts into a package manifest. These configuration files can also be added as part of any automations used to bootstrap new feature creation.

## Installation

Package Manifest Generator may be used either as a standalone CLI tool or as a Swift Package Manager plugin.

### Executable

You can use [Mint](https://github.com/yonaskolb/mint) to install `package-manifest-generator`:

```sh
$ mint install mgacy/package-manifest-generator
```

Alternatively, you can use the [Makefile](Makefile) to build and install:

```sh
$ make install
```

### SwiftPM Command Plugin

To use Package Manifest Generator as a SwiftPM plugin, simply add it as a package dependency; there is no need to add it to any target dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/mgacy/package-manifest-generator.git", from: "0.1.0")
    ...
]
```

Invoke the command plugin with:

```sh
$ swift package generate-manifest --allow-writing-to-package-directory
```

## Usage

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
target:
  name: MyTarget # If no value is provided the name of the parent directory will be used.
  dependencies:
    # Target dependencies can be specified by their name.
    - Basic
    # Other dependency types must be defined explicitly.
    - name: Product
      type: product # Valid options: `target` | `product` | `byName`
      package: package # Only valid for the `product` type.
  path: path/to/target
  exclude:
    - excluded.txt
  sources:
    - foo.swift
  resources:
    - path: path/to/resource.txt
      rule: process # Valid options: `copy` | `embed` | `process` (Default)
      localization: base # Only valid for `process` type. Valid options: `base` | `default`
  packageAccess: true # Default: `true`
  plugins:
    - name: Plugin
      package: package
```

Regular and executable targets are configured with YAML representations of [`SourceConfiguration`](Sources/PackageManifestGeneratorCore/Models/Configurations/SourceConfiguration.swift):

```yaml
type: regular # Valid options: `regular` (default) | `executable`
target:
  # See above.
products:
  - name: ProductName
    type: library # Valid options: `executable` | `library` (Default) | `dynamicLibrary` | `staticLibrary`
    targets:
      - MyTarget
```

Test targets are configured using YAML representations of [`TestConfiguration`](Sources/PackageManifestGeneratorCore/Models/Configurations/TestConfiguration.swift):

```yaml
target:
  # See above.
```

## Example

As a demonstration, take a package with the following manifest, where the comments represent the desired products and targets:

```swift
let package = Package(
    name: "Paper",
    // The desired products:
    // products: [
    //     .executable(name: "tool", targets: ["tool"]),
    //     .library(name: "Paper", targets: ["Paper"]),
    //     .library(name: "PaperStatic", type: .static, targets: ["Paper"])
    // ],
    dependencies: [
        .package(url: "http://example.com/ExamplePackage/ExamplePackage", from: "1.2.3")
    ]
    // The desired targets:
    // targets: [
    //     .executableTarget(
    //         name: "tool",
    //         dependencies: [
    //             "Paper"
    //         ]
    //     ),
    //     .target(
    //         name: "Paper",
    //         dependencies: [
    //             .product(name: "ExamplePackage", package: "example-package")
    //         ]
    //     ),
    //     .testTarget(
    //         name: "PaperTests",
    //         dependencies: [
    //             "Paper"
    //         ]
    //     )
    // ]
)
```

Such a package would have the following configuration files:

**tool:**

```yaml
# `Sources/tool/_config.yml`
type: executable
target:
  dependencies:
    - Paper
products:
  - type: executable
```

**Paper:**

```yaml
# `Sources/Paper/_config.yml`
target:
  dependencies:
    - name: ExamplePackage
      package: example-package
products:
  - type: library
  - name: PaperStatic
    type: staticLibrary
    targets: [Paper]
```

**PaperTests:**

```yaml
# `Tests/PaperTests/_config.yml`
target:
  dependencies:
    - Paper
```

Running `package-manifest-generator` would update the manifest to add the configured products and targets:

```swift
let package = Package( ... )

// Code between this separator and the next is autogenerated; do not edit
// MARK: - Autogenerated

var generatedProducts: [Product] = [
    .executable(name: "tool", targets: ["tool"]),
    .library(name: "Paper", targets: ["Paper"]),
    .library(name: "PaperStatic", type: .static, targets: ["Paper"])
]

var generatedTargets: [Target] = [
    .executableTarget(
        name: "tool",
        dependencies: [
            "Paper"
        ]
    ),
    .target(
        name: "Paper",
        dependencies: [
            .product(name: "ExamplePackage", package: "example-package")
        ]
    ),
    .testTarget(
        name: "PaperTests",
        dependencies: [
            "Paper"
        ]
    )
]

for target in generatedTargets {
    if !target.exclude.contains("_config.yml") {
        target.exclude.append("_config.yml"
    }
}

// Code below this separator may be edited
// MARK: End Autogenerated -

package.products += generatedProducts
package.targets += generatedTargets
```

Any modifications to the manifest after the `// MARK: End Autogenerated -` comment will be preserved by subsequent invocations of the tool to allow manipulation beyond what is supported by the configuration file format:

```swift
...
// Code below this separator may be edited
// MARK: End Autogenerated -

for target in generatedTargets.filter({ !$0.isTest }) {
    target.swiftSettings = [.enableExperimentalFeature("StrictConcurrency")]
}

package.products += generatedProducts
package.targets += generatedTargets
```
