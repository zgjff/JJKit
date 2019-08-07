import CoreGraphics

public protocol LayoutRelationValueable {}
extension LayoutRelationValueable {
    var cgFloat: CGFloat {
        if let value = self as? CGFloat {
            return value
        }
        if let value = self as? Int {
            return CGFloat(value)
        }
        if let value = self as? Double {
            return CGFloat(value)
        }
        if let value = self as? Float {
            return CGFloat(value)
        }
        return 0
    }
}

extension Int: LayoutRelationValueable {}
extension CGFloat: LayoutRelationValueable {}
extension Double: LayoutRelationValueable {}
extension Float: LayoutRelationValueable {}
