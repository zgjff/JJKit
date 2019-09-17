import UIKit

extension JJLayout {
    public class TargetRelation {
        internal required init() {}
        internal var change: ((Style) -> ())?
    }
}

extension JJLayout.TargetRelation {
    /// LayoutItem与目标LayoutTargetable之间的数学关系
    ///
    /// - equal: 相等
    /// - transform: 转换
    ///
    ///     - 如果是LayoutCGFloatTargetRelation则transform只有第一个有用。比如LayoutCGFloatTargetable设置设置为view.width，则最终结果为viwe.width + transform.0
    ///     - 如果是LayoutPointTargetRelation则transform前两个有用。比如LayoutPointTargetable设置为view，则最终结果为CGPoint(x: view.center.x + transform.0, y: view.center.y + transform.1)
    ///     - 如果是LayoutSizeTargetRelation则transform前两个有用。比如LayoutSizeTargetable设置为view，则最终结果为CGSize(width: view.width + transform.0, height: view.size.height + transform.1)
    ///     - 如果是LayoutRectTargetable则transform都有用。比如LayoutRectTargetable设置为view，则最终结果为CGRect(x: view.x + transform.0, y: view.y + transform.1, width: view.width + transform.2, height: view.height + transform.3)
    /// - multiplied: 倍数关系
    internal enum Style {
        case equal
        case transform(CGFloat, CGFloat, CGFloat, CGFloat)
        case multiplied(CGFloat)
    }
}

extension JJLayout.TargetRelation {
    public class TFloat: JJLayout.TargetRelation {
        public func offsetBy(_ amount: LayoutRelationValueable) {
            change?(.transform(amount.cgFloat, 0, 0, 0))
        }
        public func multipliedBy(_ amount: LayoutRelationValueable) {
            change?(.multiplied(amount.cgFloat))
        }
    }
}

extension JJLayout.TargetRelation {
    public class Point: JJLayout.TargetRelation {
        public func offsetBy(_ x: LayoutRelationValueable, _ y: LayoutRelationValueable) {
            change?(.transform(x.cgFloat, y.cgFloat, 0, 0))
        }
        public func multipliedBy(_ amount: LayoutRelationValueable) {
            change?(.multiplied(amount.cgFloat))
        }
    }
}

extension JJLayout.TargetRelation {
    public class Size: JJLayout.TargetRelation {
        public func offsetBy(_ width: LayoutRelationValueable, _ height: LayoutRelationValueable) {
            change?(.transform(width.cgFloat, height.cgFloat, 0, 0))
        }
        public func multipliedBy(_ amount: LayoutRelationValueable) {
            change?(.multiplied(amount.cgFloat))
        }
    }
}

extension JJLayout.TargetRelation {
    public class Rect: JJLayout.TargetRelation {
        public func offsetBy(_ dx: LayoutRelationValueable, _ dy: LayoutRelationValueable) {
            change?(.transform(dx.cgFloat, dy.cgFloat, -dx.cgFloat * 2, -dy.cgFloat * 2))
        }
        public func offsetBy(_ insets: UIEdgeInsets) {
            change?(.transform(insets.left, insets.top, -(insets.left + insets.right), -(insets.top + insets.bottom)))
        }
    }
}
