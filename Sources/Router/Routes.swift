//
//  Routes.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import Foundation

protocol Routes: CustomStringConvertible {
    /// 注册路由
    /// - Parameter pattern: 路由path
    /// - Returns: 返回注册的路由解析数据
    func register(pattern: String) throws -> JJRouter.Route
    
    /// 匹配路由
    /// - Parameter url: 路由
    /// - Returns: 匹配的结果
    func match(_ url: URL) -> Result<RouteMatchResult, MatchRouteError>
}

/// 注册路由错误
enum RegisterRouteError: Error, CustomStringConvertible {
    /// 路由path为空
    case emptyPattern
    /// 已经存在相同模式的路由: 存在的路由
    case alreadyExists(oldRoute: JJRouter.Route)
    
    var description: String {
        switch self {
        case .emptyPattern:
            return "路由格式为空"
        case .alreadyExists(let oldRoute):
            return "已经存在相同模式的路由: \(oldRoute)"
        }
    }
}

enum MatchRouteError: Error, CustomStringConvertible {
    case emptyRoutes
    case emptyPattern
    case notMatch
    
    var description: String {
        switch self {
        case .emptyRoutes:
            return "未注册路由"
        case .emptyPattern:
            return "路由格式为空"
        case .notMatch:
            return "没有匹配到路由"
        }
    }
}
