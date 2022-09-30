//
//  CALayer+Frame.swift
//  JJKit
//
//  Created by 郑桂杰 on 2022/9/30.
//

import UIKit

extension CALayer: JJCompatible {}

public extension JJBox where Base: CALayer {
    @discardableResult
    func addLayers(_ layers: CALayer...) -> Base {
        layers.forEach { base.addSublayer($0) }
        return base
    }
    
    func setCornerRadius(_ radius: CGFloat, corner: UIRectCorner) {
        base.cornerRadius = radius
        if corner.contains(.allCorners) {
            base.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            return
        }
        var maskedCorners: CACornerMask = []
        if corner.contains(.topLeft) {
            maskedCorners.insert(.layerMinXMinYCorner)
        }
        if corner.contains(.topRight) {
            maskedCorners.insert(.layerMaxXMinYCorner)
        }
        if corner.contains(.bottomLeft) {
            maskedCorners.insert(.layerMinXMaxYCorner)
        }
        if corner.contains(.bottomRight) {
            maskedCorners.insert(.layerMaxXMaxYCorner)
        }
        base.maskedCorners = maskedCorners
    }
}

public extension JJBox where Base: CALayer {
    var top: CGFloat {
        get { return base.frame.origin.y }
        set {
            var newFrame = base.frame
            newFrame.origin.y = newValue
            base.frame = newFrame
        }
    }
    
    @discardableResult
    func top(is top: CGFloat) -> Self {
        var newFrame = base.frame
        newFrame.origin.y = top
        base.frame = newFrame
        return self
    }

    var bottom: CGFloat {
        get { return base.frame.origin.y + base.frame.size.height }
        set {
            var newFrame = base.frame
            newFrame.origin.y = newValue - base.frame.size.height
            base.frame = newFrame
        }
    }
    
    @discardableResult
    func bottom(is bottom: CGFloat) -> Self {
        var newFrame = base.frame
        newFrame.origin.y = bottom - base.frame.size.height
        base.frame = newFrame
        return self
    }
    
    var left: CGFloat {
        get { return base.frame.origin.x }
        set {
            var newFrame = base.frame
            newFrame.origin.x = newValue
            base.frame = newFrame
        }
    }
    
    @discardableResult
    func left(is left: CGFloat) -> Self {
        var newFrame = base.frame
        newFrame.origin.x = left
        base.frame = newFrame
        return self
    }
    
    var right: CGFloat {
        get { return base.frame.origin.x + base.frame.size.width }
        set {
            var newFrame = base.frame
            newFrame.origin.x = newValue - base.frame.size.width
            base.frame = newFrame
        }
    }
    
    @discardableResult
    func right(is right: CGFloat) -> Self {
        var newFrame = base.frame
        newFrame.origin.x = right - base.frame.size.width
        base.frame = newFrame
        return self
    }
    
    var centerX: CGFloat {
        get { return base.frame.origin.x + base.frame.size.width * 0.5 }
        set {
            var newFrame = base.frame
            newFrame.origin.x = newValue - newFrame.size.width * 0.5
            base.frame = newFrame
        }
    }
    
    @discardableResult
    func centerX(is centerX: CGFloat) -> Self {
        var newFrame = base.frame
        newFrame.origin.x = centerX - newFrame.size.width * 0.5
        base.frame = newFrame
        return self
    }
    
    var centerY: CGFloat {
        get { return base.frame.origin.y + base.frame.size.height * 0.5 }
        set {
            var newFrame = base.frame
            newFrame.origin.y = newValue - newFrame.size.height * 0.5
            base.frame = newFrame
        }
    }
    
    @discardableResult
    func centerY(is centerY: CGFloat) -> Self {
        var newFrame = base.frame
        newFrame.origin.y = centerY - newFrame.size.height * 0.5
        base.frame = newFrame
        return self
    }
    
    var width: CGFloat {
        get { return base.frame.size.width }
        set {
            var newFrame = base.frame
            newFrame.size.width = newValue
            base.frame = newFrame
        }
    }
    
    @discardableResult
    func width(is width: CGFloat) -> Self {
        var newFrame = base.frame
        newFrame.size.width = width
        base.frame = newFrame
        return self
    }

    var height: CGFloat {
        get { return base.frame.size.height }
        set {
            var newFrame = base.frame
            newFrame.size.height = newValue
            base.frame = newFrame
        }
    }
    
    @discardableResult
    func height(is height: CGFloat) -> Self {
        var newFrame = base.frame
        newFrame.size.height = height
        base.frame = newFrame
        return self
    }
    
    var origin: CGPoint {
        get { return base.frame.origin }
        set {
            var newFrame = base.frame
            newFrame.origin = newValue
            base.frame = newFrame
        }
    }
    
    @discardableResult
    func origin(is origin: CGPoint) -> Self {
        var newFrame = base.frame
        newFrame.origin = origin
        base.frame = newFrame
        return self
    }
    
    var size: CGSize {
        get { return base.frame.size }
        set {
            var newFrame = base.frame
            newFrame.size = newValue
            base.frame = newFrame
        }
    }
    
    @discardableResult
    func size(is size: CGSize) -> Self {
        var newFrame = base.frame
        newFrame.size = size
        base.frame = newFrame
        return self
    }
    
    var frame: CGRect {
        get { return base.frame }
        set { base.frame = newValue }
    }
    
    @discardableResult
    func frame(is frame: CGRect) -> Self {
        base.frame = frame
        return self
    }
    
    var bounds: CGRect {
        get { return base.bounds }
        set { base.bounds = newValue }
    }
    
    @discardableResult
    func bounds(is bounds: CGRect) -> Self {
        base.bounds = bounds
        return self
    }
    
    var center: CGPoint {
        get {
            return CGPoint(x: base.frame.origin.x + base.frame.size.width * 0.5,
                             y: base.frame.origin.y + base.frame.size.height * 0.5)
        }
        set {
            var newFrame = base.frame
            newFrame.origin.x = newValue.x - newFrame.size.width * 0.5
            newFrame.origin.y = newValue.y - newFrame.size.height * 0.5
            base.frame = newFrame
        }
    }
    
    @discardableResult
    func center(is center: CGPoint) -> Self {
        var newFrame = base.frame
        newFrame.origin.x = center.x - newFrame.size.width * 0.5
        newFrame.origin.y = center.y - newFrame.size.height * 0.5
        base.frame = newFrame
        return self
    }
}
