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

final public class JJ<Original>: NSObject {
    let original: Original
    init(_ original: Original) {
        self.original = original
    }
}
