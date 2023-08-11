//
//  JJContainerAnimator.swift
//  JJKit
//
//  Created by zgjff on 2023/8/9.
//

import UIKit

/// `toast`容器动画
public struct JJContainerAnimator {
    internal let keyPath: String
    internal let fromValue: Any?
    internal let toValue: Any?
    
    /// 初始化动画
    /// - Parameters:
    ///   - keyPath: 动画属性
    ///   - fromValue: 起始值
    ///   - toValue: 目标值
    public init?(keyPath: String, fromValue: Any?, toValue: Any?) {
        let key = keyPath.trimmingCharacters(in: .whitespacesAndNewlines)
        if key.isEmpty {
            return nil
        }
        self.keyPath = key
        self.fromValue = fromValue
        self.toValue = toValue
    }
    
    /// 获取相对的动画
    public var opposite: JJContainerAnimator {
        return JJContainerAnimator(keyPath: keyPath, fromValue: toValue, toValue: fromValue)!
    }
    
    internal var animation: CABasicAnimation {
        let obj = CABasicAnimation(keyPath: keyPath)
        obj.fromValue = fromValue
        obj.toValue = toValue
        return obj
    }
}

extension JJContainerAnimator: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(keyPath)
    }
    
    public static func == (lhs: JJContainerAnimator, rhs: JJContainerAnimator) -> Bool {
        return lhs.keyPath == rhs.keyPath
    }
}

extension JJContainerAnimator {
    /// 整体缩放动画：fromValue->1
    public static var scale: (_ fromValue: Double) -> JJContainerAnimator = { fromValue in
        let from = fromValue < 0 ? 0 : (fromValue > 1) ? 1 : fromValue
        return JJContainerAnimator(keyPath: "transform.scale", fromValue: from, toValue: 1)!
    }
    
    /// 宽度缩放动画：fromValue->1
    public static var scaleX: (_ fromValue: Double) -> JJContainerAnimator = { fromValue in
        let from = fromValue < 0 ? 0 : (fromValue > 1) ? 1 : fromValue
        return JJContainerAnimator(keyPath: "transform.scale.x", fromValue: from, toValue: 1)!
    }
    
    /// 高度缩放动画：fromValue->1
    public static var scaleY: (_ fromValue: Double) -> JJContainerAnimator = { fromValue in
        let from = fromValue < 0 ? 0 : (fromValue > 1) ? 1 : fromValue
        return JJContainerAnimator(keyPath: "transform.scale.y", fromValue: from, toValue: 1)!
    }
    
    /// 透明度动画：fromValue->1
    public static var opacity: (_ fromValue: Double) -> JJContainerAnimator = { fromValue in
        let from = fromValue < 0 ? 0 : (fromValue > 1) ? 1 : fromValue
        return JJContainerAnimator(keyPath: "opacity", fromValue: from, toValue: 1)!
    }
}
