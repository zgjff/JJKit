import Foundation

extension JJ where Original: AnyObject {
    @discardableResult
    public func config(_ block: (_ object: Original) -> Void) -> Original {
        block(original)
        return original
    }
}

