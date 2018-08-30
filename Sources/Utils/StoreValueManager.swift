import Foundation
public struct StoreValueManager {
    public static func get<ValueType: Any>(from base: Any,
                                    key: UnsafeRawPointer,
                                    initialiser: () -> ValueType) -> ValueType {
        if let associated = objc_getAssociatedObject(base, key) as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return associated
    }
    
    public static func set<ValueType: Any>(
        for base: Any,
        key: UnsafeRawPointer,
        value: ValueType) {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

