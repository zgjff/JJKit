//
//  MatchedSameRouterAction.swift
//  JJRouter
//
//  Created by zgjff on 2022/9/30.
//

import Foundation

extension JJRouter {
    /// 匹配到的路由跟当前展示的界面相同时的操作
    public enum MatchedSameRouterDestinationAction {
        /// 不做任何操作
        case none
        /// 更新数据
        case update
        /// 展示新界面
        case new
    }
}
