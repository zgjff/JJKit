//
//  SyncRoutes.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import Foundation

internal final class SyncRoutes: Routes {
    private var routes: Set<JJRouter.Route> = []
    private let scanner = JJRouter.Scanner()
}

extension SyncRoutes {
    @discardableResult
    func register(pattern: String) throws -> JJRouter.Route {
        // TODO: - 转换成url去掉scheme, 只取path
        let tokens = scanner.tokenize(pattern: pattern)
        if tokens.isEmpty {
            throw RegisterRouteError.emptyPattern
        }
        let route = JJRouter.Route(pattern: pattern, tokens: tokens)
        let (success, member) = routes.insert(route)
        if !success {
            throw RegisterRouteError.alreadyExists(oldRoute: member)
        }
        return route
    }
    
    func match(_ url: URL) -> Result<RouteMatchResult, MatchRouteError>  {
        if routes.isEmpty {
            return Result.failure(.emptyRoutes)
        }
        var pattern = url.path
        if let query = url.query {
            pattern.append("?\(query)")
        }
        if let fragment = url.fragment {
            pattern.append("#\(fragment)")
        }
        let utokens = scanner.tokenize(pattern: pattern)
        if utokens.isEmpty {
            return Result.failure(.emptyPattern)
        }
        var route = routes.makeIterator()
        var matchResult: RouteMatchResult?
        while let b = route.next() {
            if let mathed = b.match(target: utokens) {
                matchResult = RouteMatchResult(pattern: mathed.pattern, url: url, parameters: mathed.parameter)
                break
            }
        }
        guard let matchResult = matchResult else {
            return Result.failure(.notMatch)
        }
        return .success(matchResult)
    }
}

extension SyncRoutes: CustomStringConvertible {
    var description: String {
        let desc: String = routes.reduce("") { result, token in
            if result.isEmpty {
                return token.description
            }
            return "\(result),\n\(token.description)"
        }
        return "[\n\(desc)\n]"
    }
}
