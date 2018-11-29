//
//  Codable+Extensions.swift
//  Demo
//
//  Created by 123 on 2018/11/29.
//  Copyright © 2018 郑桂杰. All rights reserved.
//

/** eg:
 
 struct Model {
    let app: String
    let quota: Double
    let rate: String
    let time: String
    let id: Int
    let icon: URL?
    let url: URL? // 这个字段可能为空
 }
 
 extension Model: Codable {
    enum ModelCodingKey: String, CodingKey {
        case app   = "name"
        case quota = "amount"
        case rate  = "interest"
        case time  = "term"
        case id
        case icon  = "logoUrl"
        case url = "linkeUrl"
 }
 
 init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: ModelCodingKey.self)
        app = try c[.app, String.self]()
        rate = try c[.rate, String.self]()
        time = try c[.time, String.self]()
        icon = c[.icon, URL.self] // 因为某些带中文的url无法解析,so。。。。。(蛋疼...)
        id = c[.id, Int.self] ?? 0
        quota = c[.quota, Double.self] ?? 0
        url = c[.url, URL.self, nil]
    }
 }
 */


import Foundation
extension KeyedDecodingContainer {
    /// decode value from key
    ///
    /// - Parameters:
    ///   - key: CodingKey
    ///   - type: 要解析的数据类型
    /// - Returns: 类型为type的value
    public subscript<T>(key: KeyedDecodingContainer<K>.Key, type: T.Type) -> () throws -> T where T: Decodable {
        return { try self.decode(type, forKey: key) }
    }
    
    /// 解析String类型的值,并尝试将值转化为type类型
    ///
    /// - Parameters:
    ///   - key: CodingKey
    ///   - type: 要转化的类型
    /// - Returns: 类型为type?的value
    public subscript<T>(key: KeyedDecodingContainer<K>.Key, type: T.Type) -> T? where T: Decodable & ConvertFromString {
        if let v = try? self.decode(String.self, forKey: key) {
            return type.init(s: v)
        }
        return nil
    }
    
    /// decodeIfPresent value from key
    ///
    /// - Parameters:
    ///   - key: CodingKey
    ///   - type: 要解析的数据类型
    ///   - defaultValue: 默认value
    /// - Returns: 类型为type?的value
    public subscript<T>(key: KeyedDecodingContainer<K>.Key, type: T.Type, defaultValue: T?) -> T? where T: Decodable {
        if let v = try? decodeIfPresent(type, forKey: key) {
            return v
        } else {
            return defaultValue
        }
    }
}


public protocol ConvertFromString {
    init?(s: String)
}

extension Double: ConvertFromString {
    public init?(s: String) {
        guard let d = Double(s) else {
            return nil
        }
        self = d
    }
}

extension Float: ConvertFromString {
    public init?(s: String) {
        guard let f = Float(s) else {
            return nil
        }
        self = f
    }
}

extension Int: ConvertFromString {
    public init?(s: String) {
        guard let i = Int(s) else {
            return nil
        }
        self = i
    }
}

extension Int8: ConvertFromString {
    public init?(s: String) {
        guard let i = Int8(s) else {
            return nil
        }
        self = i
    }
}

extension Int16: ConvertFromString {
    public init?(s: String) {
        guard let i = Int16(s) else {
            return nil
        }
        self = i
    }
}

extension Int32: ConvertFromString {
    public init?(s: String) {
        guard let i = Int32(s) else {
            return nil
        }
        self = i
    }
}

extension Int64: ConvertFromString {
    public init?(s: String) {
        guard let i = Int64(s) else {
            return nil
        }
        self = i
    }
}

extension UInt: ConvertFromString {
    public init?(s: String) {
        guard let i = UInt(s) else {
            return nil
        }
        self = i
    }
}

extension UInt8: ConvertFromString {
    public init?(s: String) {
        guard let i = UInt8(s) else {
            return nil
        }
        self = i
    }
}

extension UInt16: ConvertFromString {
    public init?(s: String) {
        guard let i = UInt16(s) else {
            return nil
        }
        self = i
    }
}

extension UInt32: ConvertFromString {
    public init?(s: String) {
        guard let i = UInt32(s) else {
            return nil
        }
        self = i
    }
}

extension UInt64: ConvertFromString {
    public init?(s: String) {
        guard let i = UInt64(s) else {
            return nil
        }
        self = i
    }
}

extension Bool: ConvertFromString {
    public init?(s: String) {
        switch s {
        case "0":
            self = false
        case "1":
            self = true
        case "true":
            self = true
        case "false":
            self = false
        default:
            return nil
        }
    }
}

extension URL: ConvertFromString {
    public init?(s: String) {
        guard let u = URL(string: s) else {
            return nil
        }
        self = u
    }
}
