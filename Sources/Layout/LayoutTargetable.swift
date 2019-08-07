import UIKit

public protocol LayoutTargetable {}

/************************LayoutCGFloatTargetable***************************/
public protocol LayoutCGFloatTargetable: LayoutTargetable {}

extension LayoutCGFloatTargetable {
    internal var value: (LayoutItem) -> (CGFloat) {
        return { item in
            if let value = self as? CGFloat {
                return value
            }
            if let value = self as? Double {
                return CGFloat(value)
            }
            if let value = self as? Int {
                return CGFloat(value)
            }
            if let value = self as? Float {
                return CGFloat(value)
            }
            if case .center = item {
                return 0
            }
            if case .size = item {
                return 0
            }
            if let value = self as? UIView {
                switch item {
                case .width: return value.jj.width
                case .height: return value.jj.height
                case .top: return value.jj.top
                case .left: return value.jj.left
                case .right: return value.jj.right
                case .bottom: return value.jj.bottom
                case .centerX: return value.jj.centerX
                case .centerY: return value.jj.centerY
                default: return 0
                }
            }
            if let value = self as? CALayer {
                switch item {
                case .width: return value.jj.width
                case .height: return value.jj.height
                case .top: return value.jj.top
                case .left: return value.jj.left
                case .right: return value.jj.right
                case .bottom: return value.jj.bottom
                case .centerX: return value.jj.centerX
                case .centerY: return value.jj.centerY
                default: return 0
                }
            }
            return 0
        }
    }
}

extension UIView: LayoutCGFloatTargetable {}
extension CALayer: LayoutCGFloatTargetable {}
extension CGFloat: LayoutCGFloatTargetable {}
extension Double: LayoutCGFloatTargetable {}
extension Float: LayoutCGFloatTargetable {}
extension Int: LayoutCGFloatTargetable {}

/************************LayoutCGFloatTargetable***************************/


/************************LayoutPointTargetable***************************/
public protocol LayoutPointTargetable: LayoutTargetable {}

extension LayoutPointTargetable {
    internal var value: (LayoutItem) -> (CGPoint) {
        return { item in
            guard case .center = item else {
                return .zero
            }
            if let value = self as? UIView {
                return value.jj.center
            }
            if let value = self as? CALayer {
                return value.jj.center
            }
            if let value = self as? CGPoint {
                return value
            }
            return .zero
        }
    }
}

extension UIView: LayoutPointTargetable {}
extension CALayer: LayoutPointTargetable {}
extension CGPoint: LayoutPointTargetable {}
/************************LayoutPointTargetable***************************/


/************************LayoutSizeTargetable***************************/
public protocol LayoutSizeTargetable: LayoutTargetable {}

extension LayoutSizeTargetable {
    internal var value: (LayoutItem) -> (CGSize) {
        return { item in
            guard case .size = item else {
                return .zero
            }
            if let value = self as? UIView {
                return value.jj.size
            }
            if let value = self as? CALayer {
                return value.jj.size
            }
            if let value = self as? CGSize {
                return value
            }
            return .zero
        }
    }
}

extension UIView: LayoutSizeTargetable {}
extension CALayer: LayoutSizeTargetable {}
extension CGSize: LayoutSizeTargetable {}
/************************LayoutSizeTargetable***************************/


/************************LayoutRectTargetable***************************/
public protocol LayoutRectTargetable: LayoutTargetable {}

extension LayoutRectTargetable {
    internal var value: (LayoutItem, LayoutViewStyle) -> (CGRect) {
        return { item, source in
            guard case .frame = item else {
                return .zero
            }
            if let value = self as? UIView {
                if case let .view(v) = source, v.superview === value {
                    return value.jj.bounds
                }
                return value.jj.frame
            }
            if let value = self as? CALayer {
                if case let .layer(l) = source, l.superlayer === value {
                    return value.jj.bounds
                }
                return value.jj.frame
            }
            if let value = self as? CGRect {
                return value
            }
            return .zero
        }
    }
}
extension UIView: LayoutRectTargetable {}
extension CALayer: LayoutRectTargetable {}
extension CGRect: LayoutRectTargetable {}
/************************LayoutRectTargetable***************************/
