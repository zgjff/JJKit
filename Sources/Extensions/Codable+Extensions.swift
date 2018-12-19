//
//  Codable+Extensions.swift
//  Demo
//
//  Created by 123 on 2018/11/29.
//  Copyright © 2018 郑桂杰. All rights reserved.
//
// 用法详见: https://github.com/zgjff/CodableHelper/blob/master/README.md

import Foundation
extension KeyedDecodingContainer {
    /// decode value from key
    /// - Parameters:
    ///   - key: CodingKey
    ///   - sourceType: 要解析的原始数据类型
    /// - Returns: 类型为T的value
    public subscript<T>(key: KeyedDecodingContainer<K>.Key, sourceType: T.Type) -> () throws -> T where T: Decodable {
        return { try self.decode(sourceType, forKey: key) }
    }
    
    /// decode value from key
    /// 把字符串类型转换成对应的类型
    /// - Parameters:
    ///   - key: CodingKey
    /// - Returns: (要转换的类型) -> 对象  闭包
    public subscript<T>(key: KeyedDecodingContainer<K>.Key) -> (T.Type) throws -> T where T: Decodable & ConvertFromString {
        return { targetType in
            let value = try self.decode(String.self, forKey: key)
            return try targetType.init(s: value)
        }
    }
    
    /// decodeIfPresent value from key
    ///
    /// - Parameters:
    ///   - key: CodingKey
    ///   - type: 要解析的原始数据类型
    ///   - defaultValue: 默认value
    /// - Returns: 类型为T?的value
    public subscript<T>(key: KeyedDecodingContainer<K>.Key, sourceType: T.Type, defaultValue: T?) -> T? where T: Decodable {
        guard let value = try? self.decodeIfPresent(sourceType, forKey: key) else {
            return defaultValue
        }
        return value
    }
    
    /// decodeIfPresent value from key
    /// 把字符串类型转换成对应的类型
    /// - Parameters:
    ///   - key: CodingKey
    ///   - defaultValue: 默认value
    /// - Returns: (T.type) -> 对象?  闭包
    public subscript<T>(key: KeyedDecodingContainer<K>.Key, defaultValue: T?) -> (T.Type) ->  T? where T: Decodable & ConvertFromString {
        return { targetType in
            guard let value = try? self.decodeIfPresent(String.self, forKey: key) else {
                return defaultValue
            }
            guard let v = value else { return defaultValue }
            guard let t = try? targetType.init(s: v) else { return defaultValue }
            return t
        }
    }
}


public protocol ConvertFromString {
    init(s: String) throws
}

public struct ConvertFromStringError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return "can not covert value from String"
    }
    
    public var debugDescription: String {
        return "can not covert value from String"
    }
}

extension Double: ConvertFromString {
    public init(s: String) throws {
        guard let d = Double(s) else {
            throw ConvertFromStringError()
        }
        self = d
    }
}

extension Float: ConvertFromString {
    public init(s: String) throws {
        guard let f = Float(s) else {
            throw ConvertFromStringError()
        }
        self = f
    }
}

extension Int: ConvertFromString {
    public init(s: String) throws {
        guard let i = Int(s) else {
            throw ConvertFromStringError()
        }
        self = i
    }
}

extension Int8: ConvertFromString {
    public init(s: String) throws {
        guard let i = Int8(s) else {
            throw ConvertFromStringError()
        }
        self = i
    }
}

extension Int16: ConvertFromString {
    public init(s: String) throws {
        guard let i = Int16(s) else {
            throw ConvertFromStringError()
        }
        self = i
    }
}

extension Int32: ConvertFromString {
    public init(s: String) throws {
        guard let i = Int32(s) else {
            throw ConvertFromStringError()
        }
        self = i
    }
}

extension Int64: ConvertFromString {
    public init(s: String) throws {
        guard let i = Int64(s) else {
            throw ConvertFromStringError()
        }
        self = i
    }
}

extension UInt: ConvertFromString {
    public init(s: String) throws {
        guard let i = UInt(s) else {
            throw ConvertFromStringError()
        }
        self = i
    }
}

extension UInt8: ConvertFromString {
    public init(s: String) throws {
        guard let i = UInt8(s) else {
            throw ConvertFromStringError()
        }
        self = i
    }
}

extension UInt16: ConvertFromString {
    public init(s: String) throws {
        guard let i = UInt16(s) else {
            throw ConvertFromStringError()
        }
        self = i
    }
}

extension UInt32: ConvertFromString {
    public init(s: String) throws {
        guard let i = UInt32(s) else {
            throw ConvertFromStringError()
        }
        self = i
    }
}

extension UInt64: ConvertFromString {
    public init(s: String) throws {
        guard let i = UInt64(s) else {
            throw ConvertFromStringError()
        }
        self = i
    }
}

extension Bool: ConvertFromString {
    public init(s: String) throws {
        switch s {
        case "0", "false", "False", "FALSE":
            self = false
        case "1", "true", "True", "TRUE":
            self = true
        default:
            throw ConvertFromStringError()
        }
    }
}

extension URL: ConvertFromString {
    public init(s: String) throws {
        guard let u = URL(string: s) else {
            throw ConvertFromStringError()
        }
        self = u
    }
}
