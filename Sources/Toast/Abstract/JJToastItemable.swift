//
//  JJToastItemable.swift
//  JJKit
//
//  Created by zgjff on 2023/8/8.
//

import UIKit

/// toast样式组件代理
public protocol JJToastableDelegate: NSObjectProtocol {
    func didCalculationView(_ view: UIView, viewSize size: CGSize, sender: any JJToastItemable)
}

/// `toast`样式组件协议
public protocol JJToastItemable: AnyObject {
    associatedtype Options: JJToastItemOptions
    /// toast样式组件代理
    var delegate: JJToastableDelegate? { get set }
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
    /// 初始化文字内容`toast`样式: 默认白色,字号为17
    /// - Parameter text: 文字内容
    init(text: String)
    /// 初始化富文本内容`toast`样式
    /// - Parameter attributedString: 富文本内容
    init(attributedString: NSAttributedString)
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
