//
//  Extensions.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/16/23.
//

import Files
import Foundation

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
}

/// Easily throw generic errors with a text description.
extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}
