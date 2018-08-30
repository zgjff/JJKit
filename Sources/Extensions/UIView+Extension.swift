//
//  UIView+Extension.swift
import UIKit

extension UIView {
    public static func +(lhs: UIView, rhs: UIView) {
        lhs.addSubview(rhs)
    }
}

extension UIView: JJCompatible {}

extension JJ where Original: UIView {
    public func addViews(_ views: UIView...) {
        views.forEach { original.addSubview($0) }
    }
    
    public func removeAll() {
        original.subviews
        .forEach { $0.removeFromSuperview() }
    }
    
    public func capture() -> UIImage? {
        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
//            format.opaque = original.isOpaque
            let render = UIGraphicsImageRenderer(size: original.frame.size, format: format)
            return render.image(actions: { _ in
                original.drawHierarchy(in: original.frame, afterScreenUpdates: true)
            })
        } else {
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            defer {
                UIGraphicsEndImageContext()
            }
            if let context = UIGraphicsGetCurrentContext() {
                original.layer.render(in: context)
            }
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
}

extension JJ where Original: UIView {
    /**
     * get for frame.origin.y
     * set frame.origin.y = top
     */
    public var top: CGFloat {
        get { return original.frame.origin.y }
        set {
            var newFrame = original.frame
            newFrame.origin.y = newValue
            original.frame = newFrame
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
        get { return original.frame.origin.y + original.frame.size.height }
        set {
            var newFrame = original.frame
            newFrame.origin.y = newValue - original.frame.size.height
            original.frame = newFrame
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
        get { return original.frame.origin.x }
        set {
            var newFrame = original.frame
            newFrame.origin.x = newValue
            original.frame = newFrame
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
        get { return original.frame.origin.x + original.frame.size.width }
        set {
            var newFrame = original.frame
            newFrame.origin.x = newValue - original.frame.size.width
            original.frame = newFrame
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
        get { return original.center.x }
        set {
            original.center = CGPoint(x: newValue, y: original.center.y)
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
        get { return original.center.y }
        set {
            original.center = CGPoint(x: original.center.x, y: newValue)
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
        get { return original.frame.size.width }
        set {
            var newFrame = original.frame
            newFrame.size.width = newValue
            original.frame = newFrame
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
        get { return original.frame.size.height }
        set {
            var newFrame = original.frame
            newFrame.size.height = newValue
            original.frame = newFrame
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
        get { return original.frame.origin }
        set {
            var newFrame = original.frame
            newFrame.origin = newValue
            original.frame = newFrame
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
        get { return original.frame.size }
        set {
            var newFrame = original.frame
            newFrame.size = newValue
            original.frame = newFrame
        }
    }
    @discardableResult
    public func size(is size: CGSize) -> Self {
        self.size = size
        return self
    }
    public var frame: CGRect {
        get { return original.frame }
        set { original.frame = newValue }
    }
    @discardableResult
    public func frame(is frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    public var bounds: CGRect {
        get { return original.bounds }
        set { original.bounds = newValue }
    }
    @discardableResult
    public func bounds(is bounds: CGRect) -> Self {
        self.bounds = bounds
        return self
    }
    public var center: CGPoint {
        get { return original.center }
        set {  original.center = newValue }
    }
    @discardableResult
    public func center(is center: CGPoint) -> Self {
        self.center = center
        return self
    }
}
