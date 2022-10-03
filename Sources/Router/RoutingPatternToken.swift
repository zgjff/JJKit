//
//  RoutingPatternToken.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import Foundation

extension JJRouter {
    internal enum RoutingPatternToken {
        case slash
        case path(String)
        case variable(key: String)
        case search(key: String, value: String)
        case fragment(value: String)
    }
}

extension JJRouter.RoutingPatternToken: CustomStringConvertible {
    var description: String {
        switch self {
        case .slash:
            return "[Slash]"
        case .path(let value):
            return "[Path \"\(value)\"]"
        case let .search(key: k, value: v):
            return "[Query \"\(k)=\(v)\"]"
        case let .variable(key: k):
            return "[Variable \"\(k)\"]"
        case .fragment(value: let v):
            return "[Fragment \"\(v)\"]"
        }
    }
}

extension JJRouter.RoutingPatternToken: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.slash, .slash):
            return true
        case let (.path(lval), .path(rval)):
             return lval == rval
        case let (.search(key: k1, value: v1), .search(key: k2, value: v2)):
            return (k1 == k2) && (v1 == v2)
        case let (.variable(key: k1), .variable(key: k2)):
            return k1 == k2
        case let (.fragment(value: v1), .fragment(value: v2)):
            return v1 == v2
        default:
            return false
        }
    }
}
