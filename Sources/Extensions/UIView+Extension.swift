//
//  UIView+Extension.swift
//  Demo
//
//  Created by 123 on 2018/6/29.
//  Copyright © 2018年 郑桂杰. All rights reserved.
//

import UIKit

extension UIView {
    public static func +(lhs: UIView, rhs: UIView) {
        lhs.addSubview(rhs)
    }
}

extension UIView: JJCompatible {}

extension JJ where Base: UIView {
    public func addViews(_ views: UIView...) {
        views.forEach { base.addSubview($0) }
    }
    
    public func removeAll() {
        base.subviews
        .forEach { $0.removeFromSuperview() }
    }
}

extension JJ where Base: UIView {
    /**
     * get for frame.origin.y
     * set frame.origin.y = top
     */
    public var top: CGFloat {
        get { return base.frame.origin.y }
        set {
            var newFrame = base.frame
            newFrame.origin.y = newValue
            base.frame = newFrame
        }
    }
    @discardableResult
    public func top(is top: CGFloat) -> Self {
        self.top = top
        return self
    }
    /**
     * get for self.frame.origin.y + self.frame.size.height
     * set frame.origin.y = bottom - frame.size.height
     */
    public var bottom: CGFloat {
        get { return base.frame.origin.y + base.frame.size.height }
        set {
            var newFrame = base.frame
            newFrame.origin.y = newValue - base.frame.size.height
            base.frame = newFrame
        }
    }
    @discardableResult
    public func bottom(is bottom: CGFloat) -> Self {
        self.bottom = bottom
        return self
    }
    /**
     * get for frame.origin.x
     * set frame.origin.x = left
     */
    public var left: CGFloat {
        get { return base.frame.origin.x }
        set {
            var newFrame = base.frame
            newFrame.origin.x = newValue
            base.frame = newFrame
        }
    }
    @discardableResult
    public func left(is left: CGFloat) -> Self {
        self.left = left
        return self
    }
    /**
     * get for self.frame.origin.x + self.frame.size.width
     * set frame.origin.x = right - frame.size.width
     */
    public var right: CGFloat {
        get { return base.frame.origin.x + base.frame.size.width }
        set {
            var newFrame = base.frame
            newFrame.origin.x = newValue - base.frame.size.width
            base.frame = newFrame
        }
    }
    @discardableResult
    public func right(is right: CGFloat) -> Self {
        self.right = right
        return self
    }
    /**
     * Shortcut for center.x
     * Sets center.x = centerX
     */
    public var centerX: CGFloat {
        get { return base.center.x }
        set {
            base.center = CGPoint(x: newValue, y: base.center.y)
        }
    }
    @discardableResult
    public func centerX(is centerX: CGFloat) -> Self {
        self.centerX = centerX
        return self
    }
    /**
     * Shortcut for center.y
     * Sets center.y = centerY
     */
    public var centerY: CGFloat {
        get { return base.center.y }
        set {
            base.center = CGPoint(x: base.center.x, y: newValue)
        }
    }
    @discardableResult
    public func centerY(is centerY: CGFloat) -> Self {
        self.centerY = centerY
        return self
    }
    /**
     * get for self.frame.size.width
     * set frame.size.width = width
     */
    public var width: CGFloat {
        get { return base.frame.size.width }
        set {
            var newFrame = base.frame
            newFrame.size.width = newValue
            base.frame = newFrame
        }
    }
    @discardableResult
    public func width(is width: CGFloat) -> Self {
        self.width = width
        return self
    }
    /**
     * get for self.frame.size.height
     * set frame.size.height = height
     */
    public var height: CGFloat {
        get { return base.frame.size.height }
        set {
            var newFrame = base.frame
            newFrame.size.height = newValue
            base.frame = newFrame
        }
    }
    @discardableResult
    public func height(is height: CGFloat) -> Self {
        self.height = height
        return self
    }
    /**
     * get for self.frame.origin
     * set frame.origin = origin
     */
    public var origin: CGPoint {
        get { return base.frame.origin }
        set {
            var newFrame = base.frame
            newFrame.origin = newValue
            base.frame = newFrame
        }
    }
    @discardableResult
    public func origin(is origin: CGPoint) -> Self {
        self.origin = origin
        return self
    }
    /**
     * get for self.frame.size
     * set frame.size = size
     */
    public var size: CGSize {
        get { return base.frame.size }
        set {
            var newFrame = base.frame
            newFrame.size = newValue
            base.frame = newFrame
        }
    }
    @discardableResult
    public func size(is size: CGSize) -> Self {
        self.size = size
        return self
    }
    public var frame: CGRect {
        get { return base.frame }
        set { base.frame = newValue }
    }
    @discardableResult
    public func frame(is frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    public var bounds: CGRect {
        get { return base.bounds }
        set { base.bounds = newValue }
    }
    @discardableResult
    public func bounds(is bounds: CGRect) -> Self {
        self.bounds = bounds
        return self
    }
    public var center: CGPoint {
        get { return base.center }
        set { base.center = newValue }
    }
    @discardableResult
    public func center(is center: CGPoint) -> Self {
        self.center = center
        return self
    }
}