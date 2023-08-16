//
//  UIView+Toast.swift
//  JJKit
//
//  Created by zgjff on 2023/8/8.
//

import UIKit

// MARK: - 操作 `Toast`,通用方法
public extension JJBox where Base: UIView {
    /// 根据对应的`toast`样式生成相应的链式操作
    /// - Parameter item: `toast`
    /// - Returns: `toast`链式操作
    func makeToast<T>(_ item: T) -> JJToastDSL<T> where T: JJToastItemable {
        JJToastDSL(view: base, item: item)
    }

    /// 隐藏`toast`
    /// - Parameters:
    ///   - container: `toast`容器
    ///   - flag: 是否开启动画
    func dismiss(toast container: JJToastContainer, animated flag: Bool = true) {
        container.dismiss(animated: flag)
    }

    /// 隐藏所有的`toast`
    /// - Parameter flag: 是否开启动画
    func dismissAllToasts(animated flag: Bool = false) {
        base.shownContaienrQueue.forEach{ $0.dismiss(animated: flag) }
    }
}

// MARK: - 生成`Toast`的快捷方法
public extension JJBox where Base: UIView {
    /// 显示文字样式`toast`
    /// - Parameters:
    ///   - message: 文字内容
    ///   - duration: 时间: 默认2s
    ///   - position: 位置: 默认居中
    ///   - didDisappear: 消失回调
    /// - Returns: `toast`容器
    @discardableResult
    func show(message: String, duration: JJToastDuration = .seconds(2), position: JJToastPosition = .center, didDisappear: (() -> ())? = nil) -> any JJToastContainer {
        JJToastDSL(view: base, item: JJTextToastItem(text: message))
            .duration(duration)
            .position(position)
            .didDisappear {
                didDisappear?()
            }
            .show()
    }
    
    /// 显示一个永久显示的系统转动指示器样式`toast`
    /// - Returns: `toast`容器
    @discardableResult
    func showActivityIndicator() -> any JJToastContainer {
        JJToastDSL(view: base, item: JJActivityToastItem())
            .duration(.distantFuture)
            .show()
    }
    
    /// 隐藏系统转动指示器样式`toast`
    func dismissActivityIndicator(animated flag: Bool) {
        for object in base.shownContaienrQueue.all {
            if let item = object.toastItem, item.identifier == JJToastItemIdentifiers.activity.identifier {
                object.dismiss(animated: flag)
            }
        }
    }
    
    /// 显示一个永久显示的三色转动动指示器样式`toast`
    /// - Returns: `toast`容器
    @discardableResult
    func showArcrotationIndicator() -> any JJToastContainer {
        JJToastDSL(view: base, item: JJArcrotationToastItem())
            .duration(.distantFuture)
            .show()
    }
    
    /// 隐藏三色转动指示器样式`toast`
    func dismissArcrotationIndicator(animated flag: Bool) {
        for object in base.shownContaienrQueue.all {
            if let item = object.toastItem, item.identifier == JJToastItemIdentifiers.arcrotation.identifier {
                object.dismiss(animated: flag)
            }
        }
    }
}
