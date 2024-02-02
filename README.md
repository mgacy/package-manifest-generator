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

To use Package Manifest Generator as a SwiftPM plugin simply add it as a package dependency; there is no need to add it to any target dependencies:

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
