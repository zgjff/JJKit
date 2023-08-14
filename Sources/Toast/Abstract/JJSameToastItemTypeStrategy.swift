//
//  JJSameToastItemTypeStrategy.swift
//  JJKit
//
//  Created by zgjff on 2023/8/14.
//

import UIKit

/// 同一个view上出现相同样式的`Toast`的处理策略
public protocol JJSameToastItemTypeStrategy {
    /// 将要显示`toast`
    /// - Parameters:
    ///   - container: `toast`容器
    ///   - viewToShow: 显示`toast`的`view`
    ///   - animatedFlag: 显示动画标志
    func toatContainer(_ container: some JJToastContainer, willPresentIn viewToShow: UIView, animated animatedFlag: Bool)
}
