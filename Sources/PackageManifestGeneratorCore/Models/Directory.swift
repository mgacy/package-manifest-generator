//
//  Directory.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 1/28/24.
//

import Foundation

struct Directory<C: Equatable>: Equatable {
    let name: String
    let configuration: C
}
