//
//  RouterOpenFailure.swift
//  JJRouter
//
//  Created by zgjff on 2022/9/30.
//

import Foundation

extension JJRouter {
    /// 路由跳转失败
    public struct OpenFailure: Error {
        private let source: JJRouter.MatchResult.Source
        internal init(source: JJRouter.MatchResult.Source) {
            self.source = source
        }
    }
}

extension JJRouter.OpenFailure: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "OpenFailure source: \(source)"
    }
    
    public var debugDescription: String {
        return description
    }
}
