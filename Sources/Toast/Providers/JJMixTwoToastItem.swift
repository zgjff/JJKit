//
//  JJMixTwoToastItem.swift
//  Demo
//
//  Created by zgjff on 2023/8/10.
//

import UIKit

/// 混合两项`toast`的`toast`item
public final class JJMixTwoToastItem: JJToastItemable {
    weak public var delegate: JJToastableDelegate?
    public typealias Options = JJMixTwoToastItem.InnerOptions
    private var options = Options.init()
    
}

// MARK: - JJIndicatorToastItemable
extension JJMixTwoToastItem {
    public func layoutToastView(with options: Options, inViewSize size: CGSize) {
        config(with: options)
        
    }

    public func resetContentSizeWithViewSize(_ size: CGSize) {
        
    }
}

// MARK: - private
private extension JJMixTwoToastItem {
    func config(with options: Options) {
        
    }

    func calculationSize(with options: Options) -> CGSize {
        return .zero
    }
}

// MARK: - Activity配置
extension JJMixTwoToastItem {
    /// Activity的`taost`配置项
    public struct InnerOptions: JJToastItemOptions {
        public init() {}

        
    }
}
