//
//  JJWeakProxy.swift
//  JJKit
//
//  Created by zgjff on 2023/8/9.
//

import Foundation

public final class JJWeakProxy<T>: NSObject where T: NSObject {

    public private(set) weak var target: T?
    
    public init(target: T) {
        self.target = target
        super.init()
    }

    public class func proxy(withTarget target: T) -> JJWeakProxy<T> {
        return JJWeakProxy(target: target)
    }

    public override func copy() -> Any {
        guard let target = target else {
            fatalError("target deinit")
        }
        return target.copy()
    }

    public override func mutableCopy() -> Any {
        guard let target = target else {
            fatalError("target deinit")
        }
        return target.mutableCopy()
    }

    public override func method(for aSelector: Selector!) -> IMP! {
        return target?.method(for: aSelector)
    }

    public override func doesNotRecognizeSelector(_ aSelector: Selector!) {
        guard let target = target else {
            return
        }
        return target.doesNotRecognizeSelector(aSelector)
    }

    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target
    }

    public override func isEqual(_ object: Any?) -> Bool {
        return target?.isEqual(object) ?? false
    }

    public override var hash: Int {
        return target?.hash ?? 0
    }

    public override var superclass: AnyClass? {
        return target?.superclass
    }

    public override func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
        return target?.perform(aSelector)
    }

    public override func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
        return target?.perform(aSelector, with: object)
    }

    public override func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
        return target?.perform(aSelector, with: object1, with: object2)
    }

    public override func isProxy() -> Bool {
        return true
    }

    public override func isKind(of aClass: AnyClass) -> Bool {
        return target?.isKind(of: aClass) ?? false
    }

    public override func isMember(of aClass: AnyClass) -> Bool {
        return target?.isMember(of: aClass) ?? false
    }

    public override func conforms(to aProtocol: Protocol) -> Bool {
        return target?.conforms(to: aProtocol) ?? false
    }

    public override func responds(to aSelector: Selector!) -> Bool {
        return target?.responds(to: aSelector) ?? false
    }

    public override var description: String {
        return target?.description ?? "target deinit"
    }

    public override var debugDescription: String {
        return target?.debugDescription ?? "target deinit"
    }
}
