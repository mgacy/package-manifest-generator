//
//  Extensions.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 2/1/24.
//

import Foundation
import PackagePlugin

extension Path {
    /// Runs an executable at this path with the given arguments.
    ///
    /// - Parameter arguments: The arguments to pass to the executable.
    func exec(arguments: [String]) throws {
        let outputPipe = Pipe()

        let process = Process()
        process.executableURL = URL(fileURLWithPath: self.string)
        process.arguments = arguments
        process.standardOutput = outputPipe

        try process.run()
        process.waitUntilExit()

        guard
            process.terminationReason == .exit,
            process.terminationStatus == 0
        else {
            let problem = "\(process.terminationReason):\(process.terminationStatus)"
            Diagnostics.error("\(self.string) invocation failed: \(problem)")
            throw problem
        }
    }
}

/// Easily throw generic errors with a text description.
extension String: @retroactive Error {}
extension String: @retroactive LocalizedError {
    public var errorDescription: String? {
        return self
    }
}
