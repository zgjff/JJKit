//
//  JJEventDisposeBag.swift
//  EventBus
//
//  Created by zgjff on 2023/9/22.
//

import Foundation

/// 订阅清除包: 可自动取消订阅内部的所有订阅事件
///
/// 参考RxSwift的`DisposeBag`: 
public final class JJEventDisposeBag {
    private lazy var lock = NSRecursiveLock()
    private lazy var disposes: [JJEventDispose] = []
    private lazy var isDisposed = false
    public init() {}
    
    deinit {
        dispose()
    }
}

public extension JJEventDisposeBag {
    /// 添加可清除订阅资源
    /// - Parameter dispose: 可清除订阅
    func insert(_ dispose: JJEventDispose) {
        _insert(dispose)?.dispose()
    }
}

private extension JJEventDisposeBag {
    func _insert(_ dispose: JJEventDispose) -> JJEventDispose? {
        lock.lock()
        defer {
            lock.unlock()
        }
        if isDisposed {
            return dispose
        }
        disposes.append(dispose)
        return nil
    }

    func dispose() {
        let oldDisposes = self._dispose()
        for disposes in oldDisposes {
            disposes.dispose()
        }
    }

    func _dispose() -> [JJEventDispose] {
        lock.lock()
        defer {
            lock.unlock()
        }
        let disposes = self.disposes
        self.disposes.removeAll(keepingCapacity: false)
        isDisposed = true
        return disposes
    }
}
