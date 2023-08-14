//
//  JJActivityToastItem.swift
//  JJKit
//
//  Created by zgjff on 2023/8/10.
//

import UIKit

/// 显示系统`UIActivityIndicatorView`样式的`toast` item
public final class JJActivityToastItem: JJIndicatorToastItemable {
    weak public var delegate: JJToastableDelegate?
    public let identifier = JJToastItemIdentifiers.activity.identifier
    public typealias Options = JJActivityToastItem.InnerOptions
    public private(set) lazy var options = Options.init()
    private lazy var activity: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            return UIActivityIndicatorView(style: .large)
        } else {
            return UIActivityIndicatorView(style: .white)
        }
    }()
}

// MARK: - JJIndicatorToastItemable
extension JJActivityToastItem {
    public func layoutToastView(with options: Options, inViewSize size: CGSize) {
        config(with: options)
        self.options = options
        resetContentSizeWithViewSize(size)
    }

    public func resetContentSizeWithViewSize(_ size: CGSize) {
        activity.sizeToFit()
        let size = calculationSize(with: options)
        activity.frame = CGRect(x: options.margin.left, y: options.margin.top, width: activity.bounds.width, height: activity.bounds.height)
        delegate?.didCalculationView(activity, viewSize: size, sender: self)
        startAnimating()
    }
    
    public func startAnimating() {
        activity.startAnimating()
    }
}

// MARK: - private
private extension JJActivityToastItem {
    func config(with options: Options) {
        activity.style = options.style
        activity.color = options.color
    }

    func calculationSize(with options: Options) -> CGSize {
        return CGSize(width: activity.bounds.width + options.margin.left + options.margin.right, height: activity.bounds.height + options.margin.top + options.margin.bottom)
    }
}

// MARK: - Activity配置
extension JJActivityToastItem {
    /// Activity的`taost`配置项
    public struct InnerOptions: JJToastItemOptions {
        public init() {}
        public var sameToastItemTypeStrategy: JJSameToastItemTypeStrategy = JJReplaceToastWithOutAnimatorStrategy()
        
        /// 设置Activity颜色
        public var color = UIColor.white
        
        /// 设置`UIActivityIndicatorView.Style`
        public var style: UIActivityIndicatorView.Style = {
            if #available(iOS 13.0, *) {
                return UIActivityIndicatorView.Style.large
            } else {
                return .white
            }
        }()
        
        /// 设置Activity外边距
        public var margin = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    }
}
