//
//  JJMixTwoToastItem.swift
//  JJKit
//
//  Created by zgjff on 2023/8/10.
//

import UIKit

/// 混合两项`toast`样式的`toast`item
public final class JJMixTwoToastItem<First: JJToastItemable, Second: JJToastItemable>: NSObject, JJToastItemable, JJToastableDelegate {
    weak public var delegate: JJToastableDelegate?
    public let identifier: String
    public typealias Options = JJMixTwoToastItem.InnerOptions
    public private(set) lazy var options = Options.init()
    private var firstToast: First
    private var secondToast: Second
    private lazy var contentView = UIView()
    public init(first: First, second: Second) {
        self.firstToast = first
        self.secondToast = second
        identifier = first.identifier + "_" + second.identifier
        super.init()
        self.firstToast.delegate = self
        self.secondToast.delegate = self
    }
    private var firstToastProvider: SubToastProvider? {
        didSet {
            layoutViews()
        }
    }
    private var secondToastProvider: SubToastProvider? {
        didSet {
            layoutViews()
        }
    }
    
    // MARK: - JJToastableDelegate
    public func didCalculationView(_ view: UIView, viewSize size: CGSize, sender: any JJToastItemable) {
        if sender === firstToast {
            firstToastProvider = SubToastProvider(view: view, contentSize: view.bounds.size, toastSize: size)
        }
        if sender === secondToast {
            secondToastProvider = SubToastProvider(view: view, contentSize: view.bounds.size, toastSize: size)
        }
    }
    
    public func triggerAutoDismiss(sender: any JJToastItemable, animated flag: Bool) {
        delegate?.triggerAutoDismiss(sender: self, animated: flag)
    }
}

// MARK: - JJIndicatorToastItemable
extension JJMixTwoToastItem {
    public func layoutToastView(with options: Options, inViewSize size: CGSize) {
        self.options = options
        resetContentSizeWithViewSize(size)
    }

    public func resetContentSizeWithViewSize(_ size: CGSize) {
        if options.layout.isTtb {
            firstToast.layoutToastView(with: options.firstOptions, inViewSize: CGSize(width: size.width, height: size.height - options.space - 30))
            secondToast.layoutToastView(with: options.secondOptions, inViewSize: CGSize(width: size.width, height: size.height - options.space - 30))
        } else {
            firstToast.layoutToastView(with: options.firstOptions, inViewSize: CGSize(width: size.width - options.space - 30, height: size.height))
            secondToast.layoutToastView(with: options.secondOptions, inViewSize: CGSize(width: size.width - options.space - 30, height: size.height))
        }
    }
}

// MARK: - private
private extension JJMixTwoToastItem {
    func layoutViews() {
        guard let firstToastProvider, let secondToastProvider else {
            return
        }
        let firstItemSize = firstToastProvider.contentSize
        let secondItemSize = secondToastProvider.contentSize
        
        let finalSize: CGSize
        if options.layout.isTtb {
            finalSize = CGSize(width: max(firstItemSize.width, secondItemSize.width) + options.margin.left + options.margin.right, height: firstItemSize.height + secondItemSize.height + options.space + options.margin.top + options.margin.bottom)
        } else {
            finalSize = CGSize(width: firstItemSize.width + secondItemSize.width + options.space + options.margin.left + options.margin.right, height: max(firstItemSize.height, secondItemSize.height) + options.margin.top + options.margin.bottom)
        }
        
        switch options.layout {
        case .ttb_left: // 上到下, 宽度较小者靠左
            firstToastProvider.view.frame = CGRect(x: options.margin.left, y: options.margin.top, width: firstItemSize.width, height: firstItemSize.height)
            secondToastProvider.view.frame = CGRect(x: options.margin.left, y: firstToastProvider.view.frame.maxY + options.space, width: secondItemSize.width, height: secondItemSize.height)
        case .ttb_center: // 上到下, 宽度较小者居中
            if firstItemSize.width > secondItemSize.width {
                firstToastProvider.view.frame = CGRect(x: options.margin.left, y: options.margin.top, width: firstItemSize.width, height: firstItemSize.height)
                secondToastProvider.view.frame = CGRect(x: (finalSize.width - secondItemSize.width) * 0.5, y: firstToastProvider.view.frame.maxY + options.space, width: secondItemSize.width, height: secondItemSize.height)
            } else {
                firstToastProvider.view.frame = CGRect(x: (finalSize.width - firstItemSize.width) * 0.5, y: options.margin.top, width: firstItemSize.width, height: firstItemSize.height)
                secondToastProvider.view.frame = CGRect(x: options.margin.left, y: firstToastProvider.view.frame.maxY + options.space, width: secondItemSize.width, height: secondItemSize.height)
            }
        case .ttb_right: // 上到下, 宽度较小者靠右
            if firstItemSize.width > secondItemSize.width {
                firstToastProvider.view.frame = CGRect(x: options.margin.left, y: options.margin.top, width: firstItemSize.width, height: firstItemSize.height)
                secondToastProvider.view.frame = CGRect(x: finalSize.width - secondItemSize.width - options.margin.right, y: firstToastProvider.view.frame.maxY + options.space, width: secondItemSize.width, height: secondItemSize.height)
            } else {
                firstToastProvider.view.frame = CGRect(x: finalSize.width - firstItemSize.width - options.margin.right, y: options.margin.top, width: firstItemSize.width, height: firstItemSize.height)
                secondToastProvider.view.frame = CGRect(x: options.margin.left, y: firstToastProvider.view.frame.maxY + options.space, width: secondItemSize.width, height: secondItemSize.height)
            }
        case .ltr_top: // 左到右, 高度较小者靠上
            firstToastProvider.view.frame = CGRect(x: options.margin.left, y: options.margin.top, width: firstItemSize.width, height: firstItemSize.height)
            secondToastProvider.view.frame = CGRect(x: firstToastProvider.view.frame.maxX + options.space, y: options.margin.top, width: secondItemSize.width, height: secondItemSize.height)
        case .ltr_center:
            if firstItemSize.height > secondItemSize.height {
                firstToastProvider.view.frame = CGRect(x: options.margin.left, y: options.margin.top, width: firstItemSize.width, height: firstItemSize.height)
                secondToastProvider.view.frame = CGRect(x: firstToastProvider.view.frame.maxX + options.space, y: (finalSize.height - secondItemSize.height) * 0.5, width: secondItemSize.width, height: secondItemSize.height)
            } else {
                firstToastProvider.view.frame = CGRect(x: options.margin.left, y: (finalSize.height - firstItemSize.height) * 0.5, width: firstItemSize.width, height: firstItemSize.height)
                secondToastProvider.view.frame = CGRect(x: firstToastProvider.view.frame.maxX + options.space, y: options.margin.top, width: secondItemSize.width, height: secondItemSize.height)
            }
        case .ltr_bottom:
            if firstItemSize.height > secondItemSize.height {
                firstToastProvider.view.frame = CGRect(x: options.margin.left, y: options.margin.top, width: firstItemSize.width, height: firstItemSize.height)
                secondToastProvider.view.frame = CGRect(x: firstToastProvider.view.frame.maxX + options.space, y: finalSize.height - secondItemSize.height - options.space, width: secondItemSize.width, height: secondItemSize.height)
            } else {
                firstToastProvider.view.frame = CGRect(x: options.margin.left, y: finalSize.height - firstItemSize.height - options.space, width: firstItemSize.width, height: firstItemSize.height)
                secondToastProvider.view.frame = CGRect(x: firstToastProvider.view.frame.maxX + options.space, y: options.margin.top, width: secondItemSize.width, height: secondItemSize.height)
            }
        }
        
        if firstToastProvider.view.superview == nil {
            contentView.addSubview(firstToastProvider.view)
        }
        if secondToastProvider.view.superview == nil {
            contentView.addSubview(secondToastProvider.view)
        }
        
        delegate?.didCalculationView(contentView, viewSize: finalSize, sender: self)
        
        self.firstToastProvider = nil
        self.secondToastProvider = nil
    }
}

// MARK: - Activity配置
extension JJMixTwoToastItem {
    /// 混合两项`toast`的`taost`配置项
    public struct InnerOptions: JJToastItemOptions {
        public init() {}
        public var sameToastItemTypeStrategy: JJSameToastItemTypeStrategy = JJReplaceToastWithOutAnimatorStrategy()
        /// 布局方式: 默认上到下, 宽度较小者居中
        public var layout = Layout.ttb_center
        /// 两者之间的间距
        public var space: CGFloat = 15
        /// 设置内容外边距
        public var margin = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        /// 第一个`toast`的配置
        public var firstOptions = First.Options.init()
        /// 第二个`toast`的配置
        public var secondOptions = Second.Options.init()
    }
    
    private struct SubToastProvider {
        let view: UIView
        let contentSize: CGSize
        let toastSize: CGSize
    }
}

extension JJMixTwoToastItem.InnerOptions {
    /// 布局方式
    public enum Layout {
        /// 上到下, 宽度较小者靠左
        case ttb_left
        /// 上到下, 宽度较小者居中
        case ttb_center
        /// 上到下, 宽度较小者靠右
        case ttb_right
        /// 左到右, 高度较小者靠上
        case ltr_top
        /// 左到右, 高度较小者居中
        case ltr_center
        /// 左到右, 高度较小者靠下
        case ltr_bottom
        
        /// 是否是上到下
        fileprivate var isTtb: Bool {
            switch self {
            case .ttb_left, .ttb_right, .ttb_center:
                return true
            case .ltr_top, .ltr_center, .ltr_bottom:
                return false
            }
        }
    }
}
