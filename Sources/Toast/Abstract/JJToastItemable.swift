//
//  JJToastItemable.swift
//  JJToast
//
//  Created by zgjff on 2023/8/8.
//

import UIKit

/// toast样式组件代理
public protocol JJToastableDelegate: NSObjectProtocol {
    /// 计算出显示`toast`内容的view及其大小
    /// - Parameters:
    ///   - view: 显示`toast`内容的view
    ///   - size: 计算出需要显示`toast`容器的大小
    ///   - sender: `toast`样式
    func didCalculationView(_ view: UIView, viewSize size: CGSize, sender: any JJToastItemable)
    /// 触发了自动隐藏
    ///
    /// 一般适用了`JJToastItemable`内部的相关逻辑引起了需要隐藏`toast`.
    /// 比如gif、`imageView`的动画达到了设定的`animationRepeatCount`、或者变换的文字达到了设定的循环次数,
    /// 这时候就需要根据需求自动隐藏`toast`容器
    /// - Parameters:
    ///   - sender: `toast`样式
    ///   - flag: 是否需要动画
    func triggerAutoDismiss(sender: any JJToastItemable, animated flag: Bool)
}

/// `toast`样式组件协议
public protocol JJToastItemable: AnyObject {
    associatedtype Options: JJToastItemOptions
    /// toast样式组件代理
    var delegate: JJToastableDelegate? { get set }
    /// 配置
    var options: Options { get }
    /// 唯一标识符
    var identifier: String { get }
    /// 使用对应的`toast`样式配置以及要显示`toast`的view的size大小, 计算并布局`toast`样式
    /// - Parameters:
    ///   - options: 配置
    ///   - size: 要显示`toast`的view的size大小
    func layoutToastView(with options: Options, inViewSize size: CGSize)
    /// 根据显示`toast`的view的size大小重置`toast`样式size
    /// - Parameter size: 显示`toast`的view的size
    func resetContentSizeWithViewSize(_ size: CGSize)
}

/// 显示文字的 `toast`样式组件协议
public protocol JJTextToastItemable: JJToastItemable {
    /// 展示文字内容
    /// - Parameters:
    ///   - text: 内容
    ///   - labelToShow: label
    func display(text: NSAttributedString, in labelToShow: UILabel)
}

/// 显示指示器的 `toast`样式组件协议
public protocol JJIndicatorToastItemable: JJToastItemable {
    /// 开始动画
    func startAnimating()
}

/// 显示进度条的 `toast`样式组件协议
public protocol JJProgressToastItemable: JJToastItemable {
    /// 设置进度条进度
    /// - Parameters:
    ///   - progress: 进度
    ///   - flag: 是否开启动画
    func setProgress(_ progress: Float, animated flag: Bool)
}
