//
//  JJEventBus.swift
//  JJEventBus
//
//  Created by zgjff on 2023/9/15.
//

import Foundation

/// 事件派发管理类
public final class JJEventBus {
    /// 默认的事件派发管理对象
    public static var `default` = JJEventBus()
    private let receivers: NSMapTable<NSString, NSMapTable<AnyObject, NSHashTable<JJEventBusReceiverDSL>>>
    private lazy var lock = NSRecursiveLock()
    
    public init() {
        receivers = .strongToStrongObjects()
    }
}

public extension JJEventBus {
    /// 订阅事件观察者
    /// - Parameters:
    ///   - observer: 观察者,同一对象可以多次订阅相同的事件
    ///   - identifier: 事件标志符
    /// - Returns: 订阅DSL
    func addObserver(_ observer: AnyObject, identifier: any JJEventIdentifier) -> JJEventBusReceiverDSL {
        let receiver = JJEventBusReceiverDSL()
        let eventKey = identifier.identifier as NSString
        lock.lock()
        defer {
            lock.unlock()
        }
        if let observers = receivers.object(forKey: eventKey) {
            let thisEventReceivers = observers.object(forKey: observer)
            if let thisEventReceivers {
                thisEventReceivers.add(receiver)
            } else {
                let eventReceivers: NSHashTable<JJEventBusReceiverDSL> = NSHashTable.init(options: .weakMemory)
                eventReceivers.add(receiver)
                observers.setObject(eventReceivers, forKey: observer)
            }
        } else {
            let eventReceivers: NSHashTable<JJEventBusReceiverDSL> = NSHashTable.init(options: .weakMemory)
            eventReceivers.add(receiver)
            
            let observers = NSMapTable<AnyObject, NSHashTable<JJEventBusReceiverDSL>>.weakToStrongObjects()
            observers.setObject(eventReceivers, forKey: observer)
            
            receivers.setObject(observers, forKey: eventKey)
        }
        return receiver
    }
}

// MARK: - dispatch
public extension JJEventBus {
    /// 发布事件: 通过此方法将会发送默认的事件model
    /// - Parameters:
    ///   - identifier: 事件标识符。此对象是个协议,`string`默认实现了此协议,所以你可以传递`string`; 或者其它实现了此协议的对象, eg: 枚举
    ///   - context: 事件内容
    func post(identifier: any JJEventIdentifier, context: Any, _ file: String = #file, _ function: String = #function, _ line: UInt = #line) {
        let event = JJDefaultEvent(identifier: identifier, context: context, file, function, line)
        post(event)
    }
    
    /// 发布事件
    /// - Parameter event: 事件model
    func post(_ event: any JJEvent) {
        let eventKey = event.identifier.identifier
        if eventKey.isEmpty {
            return
        }
        lock.lock()
        let receivers = self.receivers
        lock.unlock()
        guard let items = receivers.object(forKey: eventKey as NSString) else {
            return
        }
        let enumerator = items.objectEnumerator()
        while let receivers = enumerator?.nextObject() as? NSHashTable<JJEventBusReceiverDSL> {
            for receiver in receivers.allObjects {
                receiver.send(event: event)
            }
        }
    }
}
