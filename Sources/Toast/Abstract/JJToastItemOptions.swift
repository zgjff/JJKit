//
//  JJToastItemOptions.swift
//  Demo
//
//  Created by zgjff on 2023/8/11.
//

import Foundation

/// toast组件配置协议
public protocol JJToastItemOptions {
    /// 同一个view上出现相同样式的`Toast`的处理策略
    var sameToastItemTypeStrategy: JJSameToastItemTypeStrategy { get set }
    init()
}
