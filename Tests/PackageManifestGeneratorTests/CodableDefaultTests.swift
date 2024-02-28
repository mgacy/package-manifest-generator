//
//  CodableDefaultTests.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 2/23/24.
//

@testable import PackageManifestGeneratorCore
import Foundation
import XCTest

final class CodableDefaultTests: XCTestCase {
    struct TestModel: Codable, Equatable {
        @CodableDefault<Empty> var string: String
        @CodableDefault<EmptyArray> var array: [Int]
        @CodableDefault<EmptyDictionary> var dictionary: [String: String]
        @CodableDefault<False> var falseBool: Bool
        @CodableDefault<True> var trueBool: Bool

        init(
            string: String,
            array: [Int],
            dictionary: [String : String],
            falseBool: Bool,
            trueBool: Bool
        ) {
            self.string = string
            self.array = array
            self.dictionary = dictionary
            self.falseBool = falseBool
            self.trueBool = trueBool
        }

        static let `default` = TestModel(
            string: "",
            array: [],
            dictionary: [:],
            falseBool: false,
            trueBool: true)
    }

    let decoder = JSONDecoder()
    let encoder = JSONEncoder()

    func decode<T: Decodable>(_ type: T.Type, from json: String) throws -> T {
        try decoder.decode(type.self, from: Data(json.utf8))
    }

    func encode<T: Encodable>(_ value: T) throws -> String {
        String(decoding: try encoder.encode(value), as: UTF8.self)
    }
}

extension CodableDefaultTests {
    func testDecodeDefault() throws {
        let actual = try decode(TestModel.self, from: "{}")
        XCTAssertEqual(actual, .default)
    }

    func testEncodeDefault() throws {
        let actual = try encode(TestModel.default)
        XCTAssertEqual(actual, "{}")
    }
}
