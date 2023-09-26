//
//  RouteMatchResultSource.swift
//  JJRouter
//
//  Created by zgjff on 2022/9/30.
//

import Foundation

extension JJRouter.MatchResult {
    /// 匹配来源
    public enum Source {
        /// 通过path或者url匹配
        case url(URL)
        /// 通过具体的协议对象匹配
        case route(JJRouterSource)
    }
}

extension JJRouter.MatchResult.Source: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .url(let url):
            return "url: \(url)"
        case .route(let route):
            return "route: \(route)"
        }
    }
    
    public var debugDescription: String {
        return description
    }
}
