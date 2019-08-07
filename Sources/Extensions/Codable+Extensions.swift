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
        func covertValueFromString(_ str: String, to targetType: T.Type) throws -> T {
            if let v = targetType.init(s: str) {
                return v
            }
            throw ConvertFromStringError.default
        }
        return { targetType in
            let value = try self.decode(String.self, forKey: key)
            return try covertValueFromString(value, to: targetType)
        }
    }
    
    /// decodeIfPresent value from key
    ///
    /// - Parameters:
    ///   - key: CodingKey
    ///   - type: 要解析的原始数据类型
    /// - Returns: 类型为T?的value
    public subscript<T>(key: KeyedDecodingContainer<K>.Key, sourceType: T.Type) -> T? where T: Decodable {
        guard let value = try? self.decodeIfPresent(sourceType, forKey: key) else {
            return nil
        }
        return value
    }
    
    /// decodeIfPresent value from key
    /// 把字符串类型转换成对应的类型
    /// - Parameters:
    ///   - key: CodingKey
    ///   - defaultValue: 默认value
    /// - Returns: (T.type) -> 对象?  闭包
    public subscript<T>(key: KeyedDecodingContainer<K>.Key) -> (T.Type) -> T? where T: Decodable & ConvertFromString {
        return { targetType in
            guard let value = try? self.decodeIfPresent(String.self, forKey: key) else {
                return nil
            }
            return targetType.init(s: value)
        }
    }
}


public protocol ConvertFromString {
    init?(s: String)
}

public struct ConvertFromStringError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    
    public static var `default` = ConvertFromStringError()
    
    public var description: String {
        return "can not covert value from String"
    }
    
    public var debugDescription: String {
        return "can not covert value from String"
    }
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
        case "0", "false", "False", "FALSE":
            self = false
        case "1", "true", "True", "TRUE":
            self = true
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
