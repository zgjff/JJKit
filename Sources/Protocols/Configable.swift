import Foundation

extension JJ where Object: AnyObject {
    @discardableResult
    public func config(_ block: (_ object: Object) -> Void) -> Object {
        block(object)
        return object
    }
}
