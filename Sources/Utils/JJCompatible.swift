import Foundation

public protocol JJCompatible {
    associatedtype CompatibleObject
    var jj: CompatibleObject { get }
}

extension JJCompatible {
    public var jj: JJ<Self> {
        return JJ(self)
    }
}

final public class JJ<Object>: NSObject {
    let object: Object
    init(_ object: Object) {
        self.object = object
    }
}
