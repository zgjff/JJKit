//
//  RouterOpenSuccess.swift
//  JJKit
//
//  Created by 郑桂杰 on 2022/9/30.
//

import UIKit

extension JJRouter {
    /// 路由跳转成功
    public struct OpenSuccess {
        private let matchedResult: MatchResult
        private let matchedHandler: MatchedHandler
        internal init(matchedResult: MatchResult, matchedHandler: @escaping MatchedHandler) {
            self.matchedResult = matchedResult
            self.matchedHandler = matchedHandler
        }
    }
}

extension JJRouter.OpenSuccess {
    /// 开始跳转
    /// - Parameter from: 跳转源控制器
    @discardableResult
    public func jump(from sourceController: UIViewController?) -> JJRouter.MatchResult {
        matchedHandler(matchedResult)(sourceController)
        return matchedResult
    }
}
