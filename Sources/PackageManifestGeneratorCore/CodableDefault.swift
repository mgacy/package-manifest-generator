//
//  CodableDefault.swift
//  PackageManifestGenerator
//
//  Created by Mathew Gacy on 11/18/23.
//

import Foundation

// MARK: - CodableDefaultSource

/// A class of types providing a default value for instances of an underlying type.
public protocol CodableDefaultSource {
    /// The underlying type for which a default value is provided.
    associatedtype Value: Codable, Equatable

    /// The default value when encoding or decoding instances of a data type that do not provide
    /// one.
    static var `default`: Value { get }
}

// MARK: - Extensions

public extension KeyedDecodingContainer {
    /// Decodes a value of the given type for the given key.
    ///
    /// - Parameters:
    ///   - type: The type of value to decode.
    ///   - key: The key that the decoded value is associated with.
    /// - Returns: A value of the requested type, if present for the given key and convertible to 
    /// the requested type.
    func decode<T>(_ type: CodableDefault<T>.Type, forKey key: Key) throws -> CodableDefault<T> {
        try decodeIfPresent(T.Value.self, forKey: key)
            .flatMap(CodableDefault.init(wrappedValue:)) ?? CodableDefault()
    }
}

public extension KeyedEncodingContainer {
    /// Encodes the given value for the given key.
    ///
    /// - Parameters:
    ///   - value: The value to encode.
    ///   - key: The key to associate the value with.
    mutating func encode<T>(_ value: CodableDefault<T>, forKey key: Key) throws {
        guard value.wrappedValue != T.default else { return }
        try encode(value.wrappedValue, forKey: key)
    }
}

// MARK: - Types

/// A source of `true` values as default for Boolean members.
public enum True: CodableDefaultSource {
    public static var `default`: Bool { true }
}

/// A source of `false` values as defalt for Boolean members.
public enum False: CodableDefaultSource {
    public static var `default`: Bool { false }
}

/// A source of empty values as default for range-replaceable collections.
public enum Empty<T>: CodableDefaultSource where T: Codable & Equatable & RangeReplaceableCollection {
    public static var `default`: T { T() }
}

/// A source of empty values as default for array members.
public enum EmptyArray<E>: CodableDefaultSource where E: Codable & Equatable {
    public static var `default`: [E] { Array() }
}

/// A source of empty values as default for dictionary members.
public enum EmptyDictionary<K, V>: CodableDefaultSource where K: Codable & Hashable, V: Codable & Equatable {
    public static var `default`: [K: V] { Dictionary() }
}

// MARK: - Property Wrapper

/// A property wrapper supporting default values for members of `Codable` types when encoding or
/// decoding instances that do not specify one.
///
/// Example usage:
///
/// ```swift
/// struct MyType: Codable {
///     @CodableDefault<False> var someFlag: Bool
/// }
///
/// try JSONDecoder().decode(MyType.self, from: Data("{}".utf8)).someFlag // false
/// ```
@propertyWrapper
public struct CodableDefault<Source: CodableDefaultSource>: Codable {
    /// The underlying value referenced by the wrapper.
    public var wrappedValue: Source.Value

    /// Creates a member using the source's ``CodableDefaultSource/default`` as the default if
    /// none is provided when encoding or decoding instances of a data type.
    public init() {
        wrappedValue = Source.default
    }

    /// Creates a member using the given value as a default when encoding or decoding instances of
    /// a data type.
    ///
    /// - Parameter wrappedValue: The default value.
    public init(wrappedValue: Source.Value) {
        self.wrappedValue = wrappedValue
    }
}

extension CodableDefault: Equatable where Source.Value: Equatable {}
extension CodableDefault: Hashable where Source.Value: Hashable {}
extension CodableDefault: Sendable where Source.Value: Sendable {}
