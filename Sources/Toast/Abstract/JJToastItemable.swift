//
//  JJToastItemable.swift
//  JJKit
//
//  Created by zgjff on 2023/8/8.
//

import UIKit

/// toast组件配置协议
public protocol JJToastItemOptions {
    init()
}

/// toast组件代理
public protocol JJToastableDelegate: NSObjectProtocol {
    func didCalculationView(_ view: UIView, viewSize size: CGSize, sender: any JJToastItemable)
}

/// toast组件协议
public protocol JJToastItemable {
    associatedtype Options: JJToastItemOptions
    var delegate: JJToastableDelegate? { get set }
    func layoutToastView(with options: Options, inViewSize size: CGSize)
    func resetContentSizeWithViewSize(_ size: CGSize)
}

/// 显示文字的 `toast`组件协议
public protocol JJTextToastItemable: JJToastItemable {
    init(text: String)
    init(attributedString: NSAttributedString)
}
