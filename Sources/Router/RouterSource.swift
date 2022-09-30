//
//  RouterSource.swift
//  JJKit
//
//  Created by 郑桂杰 on 2022/9/30.
//

import Foundation

/// 要匹配的路由来源
public protocol JJRouterSource {
    /// 注册的路由path
    var routerPattern: String { get }
    
    /// 设置的路由参数
    ///
    /// 缘由:(更多的是为了使用Swifty方式的软编码----特别是swift的枚举,类似于Moya中的task/headers)
    ///
    /// 1: 如果是通过具体注册的路由路由对象来跳转的话,此时为了快速是直接匹配字典的,不会解析url中的数据。
    /// 而JJRouter的register方法中的匹配成功,其实是hold住了最原始的注册信息,而无法拿到最新匹配的信息。
    /// eg：下面这个注册枚举
    ///
    ///     enum PassParameterRouter {
    ///         case byEnum(p: String, q: Int)
    ///     }
    ///     let registers: [PassParameterRouter] = [.byEnum(p: "", q: 0)]
    ///     registers.forEach { try! $0.register() }
    ///
    ///     使用路由跳转: JJRouter.default.open(PassParameterRouter.byEnum(p: "entry", q: 108))(self)
    ///     如果不设置`routerParameters`的话,因为注册的信息是.byEnum(p: "", q: 0),所以拿到的值永远是p="",
    ///     q=0。
    ///
    /// 2: 如果是通过path或者url来进行跳转的话,是使用不到这个设置的参数(因为根本不知道是哪个具体source注册的),只能通过解析url中的数据得到
    var routerParameters: [String: String] { get }
    
    /// 注册路由
    func register() throws

    /// 生成与路由匹配的跳转路由目标
    /// - Parameters:
    ///   - parameters: 解析的参数
    ///   - context: 路由跳转携带的内容
    /// - Returns: 匹配到的目标界面
    func makeRouterDestination(parameters: [String: String], context: Any?) -> JJRouterDestination
}

extension JJRouterSource {
    public var routerParameters: [String: String] {
        return [:]
    }
    
    public func register() throws {
        return try JJRouter.default.register(pattern: routerPattern) { _ in
            return self
        }
    }
}
