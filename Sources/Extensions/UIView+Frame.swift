//
//  UIView+Frame.swift
//  JJKit
//
//  Created by 郑桂杰 on 2022/9/30.
//

import UIKit

extension UIView: JJCompatible {}

public extension JJBox where Base: UIView {
    @discardableResult
    func addViews(_ views: UIView...) -> Base {
        views.forEach { base.addSubview($0) }
        return base
    }
}

extension JJBox where Base: UIView {
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
        var newFrame = base.frame
        newFrame.origin.y = top
        base.frame = newFrame
        return self
    }

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
        var newFrame = base.frame
        newFrame.origin.y = bottom - base.frame.size.height
        base.frame = newFrame
        return self
    }
    
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
        var newFrame = base.frame
        newFrame.origin.x = left
        base.frame = newFrame
        return self
    }
    
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
        var newFrame = base.frame
        newFrame.origin.x = right - base.frame.size.width
        base.frame = newFrame
        return self
    }

    public var centerX: CGFloat {
        get { return base.center.x }
        set {
            base.center = CGPoint(x: newValue, y: base.center.y)
        }
    }
    
    @discardableResult
    public func centerX(is centerX: CGFloat) -> Self {
        base.center = CGPoint(x: centerX, y: base.center.y)
        return self
    }
    
    public var centerY: CGFloat {
        get { return base.center.y }
        set {
            base.center = CGPoint(x: base.center.x, y: newValue)
        }
    }
    
    @discardableResult
    public func centerY(is centerY: CGFloat) -> Self {
        base.center = CGPoint(x: base.center.x, y: centerY)
        return self
    }
    
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
        var newFrame = base.frame
        newFrame.size.width = width
        base.frame = newFrame
        return self
    }
    
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
        var newFrame = base.frame
        newFrame.size.height = height
        base.frame = newFrame
        return self
    }
    
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
        var newFrame = base.frame
        newFrame.origin = origin
        base.frame = newFrame
        return self
    }
    
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
        var newFrame = base.frame
        newFrame.size = size
        base.frame = newFrame
        return self
    }
    
    public var frame: CGRect {
        get { return base.frame }
        set { base.frame = newValue }
    }
    
    @discardableResult
    public func frame(is frame: CGRect) -> Self {
        base.frame = frame
        return self
    }
    
    public var bounds: CGRect {
        get { return base.bounds }
        set { base.bounds = newValue }
    }
    
    @discardableResult
    public func bounds(is bounds: CGRect) -> Self {
        base.bounds = bounds
        return self
    }
    
    public var center: CGPoint {
        get { return base.center }
        set {  base.center = newValue }
    }
    
    @discardableResult
    public func center(is center: CGPoint) -> Self {
        base.center = center
        return self
    }
}
