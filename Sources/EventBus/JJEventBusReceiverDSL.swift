//
//  JJEventBusReceiverDSL.swift
//  JJEventBus
//
//  Created by zgjff on 2023/9/18.
//

import Foundation

/// 事件订阅链式操作
public final class JJEventBusReceiverDSL {
    private var action: ((_ context: any JJEvent) -> ())?
    private var subscribeQueue: OperationQueue?
}

public extension JJEventBusReceiverDSL {
    /// 在自定义的线程队列中订阅事件回调: 注意发出通知的都会在`post`调用的线程执行
    /// - Parameter queue: 线程队列
    func observeOn(queue: OperationQueue) -> Self {
        subscribeQueue = queue
        return self
    }
}

internal extension JJEventBusReceiverDSL {
    /// 发送事件
    /// - Parameter event: 事件内容
    func send(event: any JJEvent) {
        guard let subscribeQueue else {
            action?(event)
            return
        }
        subscribeQueue.addOperation { [weak self] in
            self?.action?(event)
        }
    }
}

public extension JJEventBusReceiverDSL {
    /// 订阅事件产出
    /// - Parameter onNext: 产出的事件
    /// - Returns: 可清除订阅资源
    ///
    /// 使用方法:
    ///
    /// 1: 自动取消订阅事件
    ///
    /// 1.a: 使用`dispose(by: bag)`方法,借助`JJEventDisposeBag`自动管理所有的事件集合,将在生命周期消失的时候,自动取消所有订阅事件
    ///
    /// 1.b: 使用存储属性`private var eventDispose: JJEventDispose?`,将在生命周期消失的时候,自动取消订阅事件
    ///
    /// 2: 手动取消订阅事件
    ///
    /// 2.a: 使用`dispose(by: bag)`方法借助`JJEventDisposeBag`管理; 在需要的地方重新生成新的`Bag`对象, bag会在`deinit`内部自动取消所有的订阅事件
    ///
    ///     self.bag = JJEventDisposeBag()
    ///
    /// 2.b: 使用存储属性`private var eventDispose: JJEventDispose?`, 在需要的地方调用:
    ///
    ///     self.eventDispose?.dispose()
    ///     self.eventDispose = nil
    ///
    @discardableResult
    func subscribe(onNext: @escaping (_ context: any JJEvent) -> ()) -> JJEventDispose {
        self.action = onNext
        return JJEventDispose(eventBusReceiver: self)
    }
}
