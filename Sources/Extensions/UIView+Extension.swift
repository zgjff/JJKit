import UIKit

extension UIView {
    public static func +(lhs: UIView, rhs: UIView) {
        lhs.addSubview(rhs)
    }
}

extension UIView: JJCompatible {}

extension JJ where Object: UIView {
    public func addViews(_ views: UIView...) {
        views.forEach { object.addSubview($0) }
    }
    
    public func removeAll() {
        object.subviews
        .forEach { $0.removeFromSuperview() }
    }
}

extension JJ where Object: UIView {
    /**
     * get for frame.origin.y
     * set frame.origin.y = top
     */
    public var top: CGFloat {
        get { return object.frame.origin.y }
        set {
            var newFrame = object.frame
            newFrame.origin.y = newValue
            object.frame = newFrame
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
        get { return object.frame.origin.y + object.frame.size.height }
        set {
            var newFrame = object.frame
            newFrame.origin.y = newValue - object.frame.size.height
            object.frame = newFrame
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
        get { return object.frame.origin.x }
        set {
            var newFrame = object.frame
            newFrame.origin.x = newValue
            object.frame = newFrame
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
        get { return object.frame.origin.x + object.frame.size.width }
        set {
            var newFrame = object.frame
            newFrame.origin.x = newValue - object.frame.size.width
            object.frame = newFrame
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
        get { return object.center.x }
        set {
            object.center = CGPoint(x: newValue, y: object.center.y)
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
        get { return object.center.y }
        set {
            object.center = CGPoint(x: object.center.x, y: newValue)
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
        get { return object.frame.size.width }
        set {
            var newFrame = object.frame
            newFrame.size.width = newValue
            object.frame = newFrame
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
        get { return object.frame.size.height }
        set {
            var newFrame = object.frame
            newFrame.size.height = newValue
            object.frame = newFrame
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
        get { return object.frame.origin }
        set {
            var newFrame = object.frame
            newFrame.origin = newValue
            object.frame = newFrame
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
        get { return object.frame.size }
        set {
            var newFrame = object.frame
            newFrame.size = newValue
            object.frame = newFrame
        }
    }
    @discardableResult
    public func size(is size: CGSize) -> Self {
        self.size = size
        return self
    }
    public var frame: CGRect {
        get { return object.frame }
        set { object.frame = newValue }
    }
    @discardableResult
    public func frame(is frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    public var bounds: CGRect {
        get { return object.bounds }
        set { object.bounds = newValue }
    }
    @discardableResult
    public func bounds(is bounds: CGRect) -> Self {
        self.bounds = bounds
        return self
    }
    public var center: CGPoint {
        get { return object.center }
        set {  object.center = newValue }
    }
    @discardableResult
    public func center(is center: CGPoint) -> Self {
        self.center = center
        return self
    }
}
