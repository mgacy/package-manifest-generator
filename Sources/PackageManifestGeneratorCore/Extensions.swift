//
//  Extensions.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/16/23.
//

import Files
import Foundation

extension Array where Element == String {
    /// Returns a string representation of the array with the given indentation style.
    ///
    /// Usage:
    ///
    /// ```swift
    /// ["foo", "bar"].asSourceArray()
    /// // [
    /// //     foo,
    /// //     bar
    /// // ]
    /// ```
    ///
    /// - Parameter style: The indentation style.
    func asSourceArray(indentationStyle style: IndentationStyle = .default) -> String {
        isEmpty
            ? "[]"
            : "[\n\(self.joined(separator: ",\n").indented(1, style: style))\n]"
    }
}

extension Collection {
    /// A Boolean value indicating whether the collection contains elements.
    var isNotEmpty: Bool {
        !isEmpty
    }
}

extension Folder {
    /// Returns the result of applying the given transformation to subfolders of this folder and the
    /// the contents of files with the given name in those subfolders.
    ///
    /// This will iterate non-recursively over a folder's subfolders, read the of data of a file
    /// with the given file name in the subfolder if one exists, and apply a transformation to that
    /// subfolder and file data.
    ///
    /// - Parameters:
    ///   - fileName: The name of the file to read in the subfolders.
    ///   - transform: The transformation to apply to the subfolder and file contents if they exist.
    /// - Returns: The results of applying the given transformation to the subfolders and contents of
    /// files with the given name in those subfolders.
    func processFilesInSubfolders<C>(
        named fileName: String,
        transform: (Folder, Data?) throws -> C?
    ) throws -> [C]? {
        var output: [C] = []
        for subfolder in subfolders {
            var data: Data?
            if subfolder.containsFile(named: fileName) {
                data = try subfolder.file(named: fileName).read()
            }

            if let transformed = try transform(subfolder, data) {
                output.append(transformed)
            }
        }

        return output
    }

    /// Return the subfolder of the given target subdirectory.
    ///
    /// - parameter name: The target directory to return.
    /// - throws: `LocationError` if the subfolder couldn't be found.
    func targetFolder(_ name: TargetDirectory) throws -> Folder {
        try subfolder(named: name.rawValue)
    }
}

extension String {
    /// Returns an indented version of the string using the given indentation style and level.
    ///
    /// - Parameters:
    ///   - level: The level of indentation.
    ///   - style: The indentation style.
    func indented(_ level: Int, style: IndentationStyle = .default) -> String {
        let prefix = Array(repeating: style.source, count: level)
            .joined(separator: "")
        let separator = "\n"
        return components(separatedBy: separator)
            .map { prefix + $0 }
            .joined(separator: separator)
    }

    /// Returns a quoted version of the string.
    func quoted() -> String {
        "\"\(self)\""
    }
}

/// Easily throw generic errors with a text description.
extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}
