//
//  Route.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import Foundation

extension JJRouter {
    internal struct Route {
        let pattern: String
        let tokens: [RoutingPatternToken]
    }
}

internal extension JJRouter.Route {
    func match(target: [JJRouter.RoutingPatternToken]) -> (pattern: String, parameter: [String: String])? {
        let sourceTokens = tokens.filter(matchFilter(token:))
        var destTokens = target.filter(matchFilter(token:))
        if (destTokens.count > 1) && (destTokens.last! == .slash) {
            destTokens.removeLast()
        }
        if sourceTokens.count != destTokens.count {
            return nil
        }
        var parameters: [String: String] = [:]
        for (source, dest) in zip(sourceTokens, destTokens) {
            switch source {
            case .slash:
                if dest != .slash {
                    return nil
                }
            case .path(let lp):
                if case let .path(rp) = dest {
                    if lp != rp {
                        return nil
                    }
                }
            case .variable(key: let key):
                if case let .path(p) = dest {
                    parameters.updateValue(p, forKey: key)
                }
            case .search, .fragment:
                continue
            }
        }
        let finalParameters = target.reduce(parameters) { partialResult, t in
            var dic = partialResult
            if case let .search(key: k, value: v) = t {
                dic.updateValue(v, forKey: k)
            }
            return dic
        }
        return (pattern, finalParameters)
    }
    
    private func matchFilter(token: JJRouter.RoutingPatternToken) -> Bool {
        switch token {
        case .slash, .path, .variable:
            return true
        case .search, .fragment:
            return false
        }
    }
}

extension JJRouter.Route: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(pattern)
    }
}

extension JJRouter.Route: Equatable {
    static func == (lhs: JJRouter.Route, rhs: JJRouter.Route) -> Bool {
        return lhs.pattern == rhs.pattern
    }
}

extension JJRouter.Route: CustomStringConvertible {
    var description: String {
        let desc: String = tokens.reduce("") { result, token in
            if result.isEmpty {
                return token.description
            }
            return "\(result), \(token.description)"
        }
        return "pattern: \(pattern)  tokens: [\(desc)]"
    }
}
