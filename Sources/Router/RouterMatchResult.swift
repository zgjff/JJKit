//
//  RouterMatchResult.swift
//  JJKit
//
//  Created by 郑桂杰 on 2022/9/30.
//

import Foundation

extension JJRouter {
    /// 路由匹配结果
    public final class MatchResult {
        /// 来源
        public let source: Source
        /// 路由参数
        public let parameters: [String: String]
        /// 路由携带的内容
        public let context: Any?
        /// 回调
        private var destinations: NSMapTable<NSString, JJRouter.Closure<Any, Void>> = .strongToStrongObjects()
        
        public init(source: Source, parameters: [String: String], context: Any?) {
            self.source = source
            self.parameters = parameters
            self.context = context
        }
        
        deinit {
            destinations.removeAllObjects()
        }
    }
}

extension JJRouter.MatchResult {
    /// 注册路由回调
    /// - Parameters:
    ///   - key: 回调名称
    ///   - callback: 回调
    public func register(Name key: String, callback: @escaping (Any) -> Void) {
        destinations.setObject(JJRouter.Closure<Any, Void>(callback), forKey: key as NSString)
    }
    
    /// 向已经注册的对应回调中进行数据回调
    /// - Parameters:
    ///   - key: 已经注册的回调名称
    ///   - object: 回调数据
    public func perform(Name key: String, withObject object: Any?) {
        if let value = destinations.object(forKey: key as NSString) {
            if let obj = object {
                value.closure(obj)
            } else {
                value.closure(())
            }
        }
    }
}

extension JJRouter.MatchResult: CustomDebugStringConvertible, CustomStringConvertible {
    public var description: String {
        if destinations.count == 0 {
            return """
            RouterMatchResult {
              \(source)
              parameters: \(parameters)
              context: \(String(describing: context))
            }
            """
        }
        return """
        RouterMatchResult {
          \(source)
          parameters: \(parameters)
          context: \(String(describing: context))
          s: \(destinations)
        }
        """
    }

    public var debugDescription: String {
        return description
    }
}

extension JJRouter {
    final fileprivate class Closure<T, U> {
        let closure: (T) -> U
        init(_ closure: @escaping (T) -> U) {
            self.closure = closure
        }
    }
}
