import UIKit

extension CALayer {
    @discardableResult
    public static func +(lhs: CALayer, rhs: CALayer) -> CALayer {
        lhs.addSublayer(rhs)
        return lhs
    }
}

extension CALayer: JJCompatible {}

public extension JJ where Object: CALayer {
    @discardableResult
    func addLayers(_ layers: CALayer...) -> Object {
        layers.forEach { object.addSublayer($0) }
        return object
    }
    @discardableResult
    func removeAll() -> Object {
        object.sublayers?
        .forEach { $0.removeFromSuperlayer() }
        return object
    }
    func setShadow(color: UIColor = .black, offset: CGSize = CGSize(width: 1, height: 1), radius: CGFloat = 3) {
        object.shadowColor = color.cgColor
        object.shadowOffset = offset
        object.shadowRadius = radius
        object.shadowOpacity = 1
        object.shouldRasterize = true
        object.rasterizationScale = UIScreen.main.scale
    }
}

public extension JJ where Object: CALayer {
    /**
     * get for frame.origin.y
     * set frame.origin.y = top
     */
    var top: CGFloat {
        get { return object.frame.origin.y }
        set {
            var newFrame = object.frame
            newFrame.origin.y = newValue
            object.frame = newFrame
        }
    }
    @discardableResult
    func top(is top: CGFloat) -> Self {
        self.top = top
        return self
    }
    /**
     * get for self.frame.origin.y + self.frame.size.height
     * set frame.origin.y = bottom - frame.size.height
     */
    var bottom: CGFloat {
        get { return object.frame.origin.y + object.frame.size.height }
        set {
            var newFrame = object.frame
            newFrame.origin.y = newValue - object.frame.size.height
            object.frame = newFrame
        }
    }
    @discardableResult
    func bottom(is bottom: CGFloat) -> Self {
        self.bottom = bottom
        return self
    }
    /**
     * get for frame.origin.x
     * set frame.origin.x = left
     */
    var left: CGFloat {
        get { return object.frame.origin.x }
        set {
            var newFrame = object.frame
            newFrame.origin.x = newValue
            object.frame = newFrame
        }
    }
    @discardableResult
    func left(is left: CGFloat) -> Self {
        self.left = left
        return self
    }
    /**
     * get for self.frame.origin.x + self.frame.size.width
     * set frame.origin.x = right - frame.size.width
     */
    var right: CGFloat {
        get { return object.frame.origin.x + object.frame.size.width }
        set {
            var newFrame = object.frame
            newFrame.origin.x = newValue - object.frame.size.width
            object.frame = newFrame
        }
    }
    @discardableResult
    func right(is right: CGFloat) -> Self {
        self.right = right
        return self
    }
    /**
     * Shortcut for center.x
     * Sets center.x = centerX
     */
    var centerX: CGFloat {
        get { return object.frame.origin.x + object.frame.size.width * 0.5 }
        set {
            var newFrame = object.frame
            newFrame.origin.x = newValue - newFrame.size.width * 0.5
            object.frame = newFrame
        }
    }
    @discardableResult
    func centerX(is centerX: CGFloat) -> Self {
        self.centerX = centerX
        return self
    }
    /**
     * Shortcut for center.y
     * Sets center.y = centerY
     */
    var centerY: CGFloat {
        get { return object.frame.origin.y + object.frame.size.height * 0.5 }
        set {
            var newFrame = object.frame
            newFrame.origin.y = newValue - newFrame.size.height * 0.5
            object.frame = newFrame
        }
    }
    @discardableResult
    func centerY(is centerY: CGFloat) -> Self {
        self.centerY = centerY
        return self
    }
    /**
     * get for self.frame.size.width
     * set frame.size.width = width
     */
    var width: CGFloat {
        get { return object.frame.size.width }
        set {
            var newFrame = object.frame
            newFrame.size.width = newValue
            object.frame = newFrame
        }
    }
    @discardableResult
    func width(is width: CGFloat) -> Self {
        self.width = width
        return self
    }
    /**
     * get for self.frame.size.height
     * set frame.size.height = height
     */
    var height: CGFloat {
        get { return object.frame.size.height }
        set {
            var newFrame = object.frame
            newFrame.size.height = newValue
            object.frame = newFrame
        }
    }
    @discardableResult
    func height(is height: CGFloat) -> Self {
        self.height = height
        return self
    }
    /**
     * get for self.frame.origin
     * set frame.origin = origin
     */
    var origin: CGPoint {
        get { return object.frame.origin }
        set {
            var newFrame = object.frame
            newFrame.origin = newValue
            object.frame = newFrame
        }
    }
    @discardableResult
    func origin(is origin: CGPoint) -> Self {
        self.origin = origin
        return self
    }
    /**
     * get for self.frame.size
     * set frame.size = size
     */
    var size: CGSize {
        get { return object.frame.size }
        set {
            var newFrame = object.frame
            newFrame.size = newValue
            object.frame = newFrame
        }
    }
    @discardableResult
    func size(is size: CGSize) -> Self {
        self.size = size
        return self
    }
    var frame: CGRect {
        get { return object.frame }
        set { object.frame = newValue }
    }
    @discardableResult
    func frame(is frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    var bounds: CGRect {
        get { return object.bounds }
        set { object.bounds = newValue }
    }
    @discardableResult
    func bounds(is bounds: CGRect) -> Self {
        self.bounds = bounds
        return self
    }
    var center: CGPoint {
        get { return CGPoint(x: object.frame.origin.x + object.frame.size.width * 0.5,
                             y: object.frame.origin.y + object.frame.size.height * 0.5)
        }
        set {
            var newFrame = object.frame
            newFrame.origin.x = newValue.x - newFrame.size.width * 0.5
            newFrame.origin.y = newValue.y - newFrame.size.height * 0.5
            object.frame = newFrame
        }
    }
    @discardableResult
    func center(is center: CGPoint) -> Self {
        self.center = center
        return self
    }
}
