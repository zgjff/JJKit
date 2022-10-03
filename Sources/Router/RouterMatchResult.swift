//
//  RouterMatchResult.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
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
        ///
        /// 为什么使用`strongToStrongObjects`,而不用`strongToWeakObjects`。
        /// 一： 有时在`perform`的时候可能发送的`object`是个block,且是个临时必包,
        /// 使用`strongToWeakObjects`的时候就可能丢弃了这个block
        ///
        /// 二：在路由注册的时候,因为某些原因转发到其它路由上(`mapRouter`)。此时注册的路由回调都会被丢弃。
        /// 参照Demo中的`onClickMapBlock`
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
    public func register(blockName key: String, callback: @escaping (Any) -> Void) {
        destinations.setObject(JJRouter.Closure<Any, Void>(callback), forKey: key as NSString)
    }
    
    /// 向已经注册的对应回调中进行数据回调
    /// - Parameters:
    ///   - key: 已经注册的回调名称
    ///   - object: 回调数据
    public func perform(blockName key: String, withObject object: Any?) {
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
