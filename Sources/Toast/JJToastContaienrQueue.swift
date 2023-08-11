//
//  JJToastContaienrQueue.swift
//  JJKit
//
//  Created by zgjff on 2023/8/9.
//

import UIKit

private var shownJJToastContainerQueueKey = 0
private var inQueueJJToastContainerQueueKey = 0

extension UIView {
    /// 正在显示的`toast`队列
    var shownContaienrQueue: JJToastContaienrQueue {
        get {
            return containerQueue(for: &shownJJToastContainerQueueKey)
        }
    }
    
    private var inQueueContaienrQueue: JJToastContaienrQueue {
        get {
            return containerQueue(for: &inQueueJJToastContainerQueueKey)
        }
    }
    
    private func containerQueue(for key: UnsafeRawPointer) -> JJToastContaienrQueue {
        if let queue = objc_getAssociatedObject(self, key) as? JJToastContaienrQueue {
            return queue
        }
        let queue = JJToastContaienrQueue()
        objc_setAssociatedObject(self, key, queue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return queue
    }
}

internal final class JJToastContaienrQueue {
    private lazy var arr: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    
    var all: [AnyObject] {
        arr.allObjects
    }
    
    func append(_ container: any JJToastContainer) {
        arr.add(container)
    }
    
    func remove(where shouldBeRemoved: (any JJToastContainer) -> Bool) {
        for object in arr.allObjects {
            if let obj = object as? JJToastContainer, shouldBeRemoved(obj) {
                arr.remove(obj)
            }
        }
    }
    
    func remove(_ container: any JJToastContainer) {
        remove(where: { $0 === container })
    }
    
    func contains(_ container: any JJToastContainer) -> Bool {
        return arr.contains(container)
    }
    
    func forEach(body: (any JJToastContainer) -> Void) {
        for obj in arr.allObjects {
            body(obj as! JJToastContainer)
        }
    }
    
    func removeAll() {
        arr.removeAllObjects()
    }
}
