import UIKit

public protocol LayoutTargetable {}

/************************LayoutCGFloatTargetable***************************/
public protocol LayoutCGFloatTargetable: LayoutTargetable {}

extension LayoutCGFloatTargetable {
    internal var value: (LayoutItem, LayoutViewStyle) -> (CGFloat) {
        return { item, source in
            if let target = self as? CGFloat {
                return target
            }
            if let target = self as? Double {
                return CGFloat(target)
            }
            if let target = self as? Int {
                return CGFloat(target)
            }
            if let target = self as? Float {
                return CGFloat(target)
            }
            if case .center = item {
                return 0
            }
            if case .size = item {
                return 0
            }
            if let target = self as? UIView {
                switch item {
                case .width: return target.jj.width
                case .height: return target.jj.height
                case .top:
                    if case let .view(v) = source {
                        return (v.superview === target) ? 0 : target.jj.top
                    }
                    if case let .layer(v) = source {
                        return (v.superlayer === target.layer) ? 0 : target.jj.top
                    }
                case .left:
                    if case let .view(v) = source {
                        return (v.superview === target) ? 0 : target.jj.left
                    }
                    if case let .layer(v) = source {
                        return (v.superlayer === target.layer) ? 0 : target.jj.left
                    }
                case .right:
                    if case let .view(v) = source {
                        return (v.superview === target) ? target.jj.width : target.jj.right
                    }
                    if case let .layer(v) = source {
                        return (v.superlayer === target.layer) ? target.jj.width : target.jj.right
                    }
                case .bottom:
                    if case let .view(v) = source {
                        return (v.superview === target) ? target.jj.height : target.jj.bottom
                    }
                    if case let .layer(v) = source {
                        return (v.superlayer === target.layer) ? target.jj.height : target.jj.bottom
                    }
                case .centerX:
                    if case let .view(v) = source {
                        return (v.superview === target) ? target.jj.width * 0.5 : target.jj.centerX
                    }
                    if case let .layer(v) = source {
                        return (v.superlayer === target.layer) ? target.jj.width * 0.5 : target.jj.centerX
                    }
                case .centerY:
                    if case let .view(v) = source {
                        return (v.superview === target) ? target.jj.height * 0.5 : target.jj.centerY
                    }
                    if case let .layer(v) = source {
                        return (v.superlayer === target.layer) ? target.jj.height * 0.5 : target.jj.centerY
                    }
                default: return 0
                }
            }
            if let target = self as? CALayer {
                switch item {
                case .width: return target.jj.width
                case .height: return target.jj.height
                case .top:
                    if case let .layer(v) = source {
                        return (v.superlayer === target) ? 0 : target.jj.top
                    }
                    if case let .view(v) = source {
                        return (target === v.layer.superlayer) ? 0 : target.jj.top
                    }
                case .left:
                    if case let .layer(v) = source {
                        return (v.superlayer === target) ? 0 : target.jj.left
                    }
                    if case let .view(v) = source {
                        return (target === v.layer.superlayer) ? 0 : target.jj.left
                    }
                case .right:
                    if case let .layer(v) = source {
                        return (v.superlayer === target) ? target.jj.width : target.jj.right
                    }
                    if case let .view(v) = source {
                        return (target === v.layer.superlayer) ? target.jj.width : target.jj.right
                    }
                case .bottom:
                    if case let .layer(v) = source {
                        return (v.superlayer === target) ? target.jj.height : target.jj.bottom
                    }
                    if case let .view(v) = source {
                        return (target === v.layer.superlayer) ? target.jj.height : target.jj.bottom
                    }
                case .centerX:
                    if case let .layer(v) = source {
                        return (v.superlayer === target) ? target.jj.width * 0.5 : target.jj.centerX
                    }
                    if case let .view(v) = source {
                        return (target === v.layer.superlayer) ? target.jj.width * 0.5 : target.jj.centerX
                    }
                case .centerY:
                    if case let .layer(v) = source {
                        return (v.superlayer === target) ? target.jj.height * 0.5 : target.jj.centerY
                    }
                    if case let .view(v) = source {
                        return (target === v.layer.superlayer) ? target.jj.height * 0.5 : target.jj.centerY
                    }
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
    internal var value: (LayoutItem, LayoutViewStyle) -> (CGPoint) {
        return { item , source in
            guard case .center = item else {
                return .zero
            }
            if let target = self as? UIView {
                if case let .view(v) = source {
                    return (v.superview === target) ? CGPoint(x: target.jj.width * 0.5, y: target.jj.height * 0.5) : target.jj.center
                }
                if case let .layer(v) = source {
                    return (v.superlayer === target.layer) ? CGPoint(x: target.jj.width * 0.5, y: target.jj.height * 0.5) : target.jj.center
                }
            }
            if let target = self as? CALayer {
                if case let .layer(v) = source {
                    return (v.superlayer === target) ? CGPoint(x: target.jj.width * 0.5, y: target.jj.height * 0.5) : target.jj.center
                }
                if case let .view(v) = source {
                    return (target === v.layer.superlayer) ? CGPoint(x: target.jj.width * 0.5, y: target.jj.height * 0.5) : target.jj.center
                }
            }
            if let target = self as? CGPoint {
                return target
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
            if let target = self as? UIView {
                return target.jj.size
            }
            if let target = self as? CALayer {
                return target.jj.size
            }
            if let target = self as? CGSize {
                return target
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
            if let target = self as? UIView {
                if case let .view(v) = source {
                    return (v.superview === target) ? target.jj.bounds : target.jj.frame
                }
                if case let .layer(v) = source {
                    return (v.superlayer === target.layer) ? target.jj.bounds : target.jj.frame
                }
            }
            if let target = self as? CALayer {
                if case let .layer(l) = source, l.superlayer === target {
                    return (l.superlayer === target) ? target.jj.bounds : target.jj.frame
                }
                if case let .view(v) = source {
                    return (target === v.layer.superlayer) ? target.jj.bounds : target.jj.frame
                }
                return target.jj.frame
            }
            if let target = self as? CGRect {
                return target
            }
            return .zero
        }
    }
}
extension UIView: LayoutRectTargetable {}
extension CALayer: LayoutRectTargetable {}
extension CGRect: LayoutRectTargetable {}
/************************LayoutRectTargetable***************************/
