//
//  Configuration.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 1/28/24.
//

import Foundation

struct Configuration<C: Equatable>: Equatable {
    let name: String
    let configuration: C
}
