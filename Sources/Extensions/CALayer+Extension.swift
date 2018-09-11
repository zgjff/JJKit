import UIKit

extension CALayer {
    public static func +(lhs: CALayer, rhs: CALayer) {
        lhs.addSublayer(rhs)
    }
}

extension CALayer: JJCompatible {}

public extension JJ where Original: CALayer {
    func addLayers(_ layers: CALayer...) {
        layers.forEach { original.addSublayer($0) }
    }
    func removeAll() {
        original.sublayers?
        .forEach { $0.removeFromSuperlayer() }
    }
    func setShadow(color: UIColor = .black, offset: CGSize = CGSize(width: 1, height: 1), radius: CGFloat = 3) {
        original.shadowColor = color.cgColor
        original.shadowOffset = offset
        original.shadowRadius = radius
        original.shadowOpacity = 1
        original.shouldRasterize = true
        original.rasterizationScale = UIScreen.main.scale
    }
}

public extension JJ where Original: CALayer {
    /**
     * get for frame.origin.y
     * set frame.origin.y = top
     */
    var top: CGFloat {
        get { return original.frame.origin.y }
        set {
            var newFrame = original.frame
            newFrame.origin.y = newValue
            original.frame = newFrame
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
        get { return original.frame.origin.y + original.frame.size.height }
        set {
            var newFrame = original.frame
            newFrame.origin.y = newValue - original.frame.size.height
            original.frame = newFrame
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
        get { return original.frame.origin.x }
        set {
            var newFrame = original.frame
            newFrame.origin.x = newValue
            original.frame = newFrame
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
        get { return original.frame.origin.x + original.frame.size.width }
        set {
            var newFrame = original.frame
            newFrame.origin.x = newValue - original.frame.size.width
            original.frame = newFrame
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
        get { return original.frame.origin.x + original.frame.size.width * 0.5 }
        set {
            var newFrame = original.frame
            newFrame.origin.x = newValue - newFrame.size.width * 0.5
            original.frame = newFrame
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
        get { return original.frame.origin.y + original.frame.size.height * 0.5 }
        set {
            var newFrame = original.frame
            newFrame.origin.y = newValue - newFrame.size.height * 0.5
            original.frame = newFrame
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
        get { return original.frame.size.width }
        set {
            var newFrame = original.frame
            newFrame.size.width = newValue
            original.frame = newFrame
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
        get { return original.frame.size.height }
        set {
            var newFrame = original.frame
            newFrame.size.height = newValue
            original.frame = newFrame
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
        get { return original.frame.origin }
        set {
            var newFrame = original.frame
            newFrame.origin = newValue
            original.frame = newFrame
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
        get { return original.frame.size }
        set {
            var newFrame = original.frame
            newFrame.size = newValue
            original.frame = newFrame
        }
    }
    @discardableResult
    func size(is size: CGSize) -> Self {
        self.size = size
        return self
    }
    var frame: CGRect {
        get { return original.frame }
        set { original.frame = newValue }
    }
    @discardableResult
    func frame(is frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    var bounds: CGRect {
        get { return original.bounds }
        set { original.bounds = newValue }
    }
    @discardableResult
    func bounds(is bounds: CGRect) -> Self {
        self.bounds = bounds
        return self
    }
    var center: CGPoint {
        get { return CGPoint(x: original.frame.origin.x + original.frame.size.width * 0.5,
                             y: original.frame.origin.y + original.frame.size.height * 0.5)
        }
        set {
            var newFrame = original.frame
            newFrame.origin.x = newValue.x - newFrame.size.width * 0.5
            newFrame.origin.y = newValue.y - newFrame.size.height * 0.5
            original.frame = newFrame
        }
    }
    @discardableResult
    func center(is center: CGPoint) -> Self {
        self.center = center
        return self
    }
    
    var contentMode: UIViewContentMode {
        get {
            switch original.contentsGravity {
            case kCAGravityResizeAspect: return .scaleAspectFit
            case kCAGravityResizeAspectFill: return .scaleAspectFill
            case kCAGravityCenter: return .center
            case kCAGravityTop: return .top
            case kCAGravityBottom: return .bottom
            case kCAGravityLeft: return .left
            case kCAGravityRight: return .right
            case kCAGravityTopLeft: return .topLeft
            case kCAGravityTopRight: return .topRight
            case kCAGravityBottomLeft: return .bottomLeft
            case kCAGravityBottomRight: return .bottomRight
            default: return .scaleToFill
            }
        }
        set {
            switch newValue {
            case .scaleToFill, .redraw:
                original.contentsGravity = kCAGravityResize
            case .scaleAspectFit:
                original.contentsGravity = kCAGravityResizeAspect
            case .scaleAspectFill:
                original.contentsGravity = kCAGravityResizeAspectFill
            case .center:
                original.contentsGravity = kCAGravityCenter
            case .top:
                original.contentsGravity = kCAGravityTop
            case .bottom:
                original.contentsGravity = kCAGravityBottom
            case .left:
                original.contentsGravity = kCAGravityLeft
            case .right:
                original.contentsGravity = kCAGravityRight
            case .topLeft:
                original.contentsGravity = kCAGravityTopLeft
            case .topRight:
                original.contentsGravity = kCAGravityTopRight
            case .bottomLeft:
                original.contentsGravity = kCAGravityBottomLeft
            case .bottomRight:
                original.contentsGravity = kCAGravityBottomRight
            }
        }
    }
}


