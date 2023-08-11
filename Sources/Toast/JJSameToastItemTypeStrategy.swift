//
//  JJSameToastItemTypeStrategy.swift
//  Demo
//
//  Created by zgjff on 2023/8/11.
//

import Foundation

/// 同一个view上出现相同样式的`Toast`的处理策略
public protocol JJSameToastItemTypeStrategy {}

/// 直接将上一个隐藏,并展示新的,且无需隐藏/显示动画
public struct JJReplaceWithOutAnimatorStrategy: JJSameToastItemTypeStrategy {
    
}
