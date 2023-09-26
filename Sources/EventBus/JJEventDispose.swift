//
//  JJEventDispose.swift
//  JJEventBus
//
//  Created by zgjff on 2023/9/22.
//

import Foundation
/// 可清除订阅事件资源
///
/// 使用方法:
///
/// 1: 自动取订阅察事件
///
/// 1.a: 使用`dispose(by: bag)`方法,借助`JJEventDisposeBag`自动管理所有的事件集合,将在生命周期消失的时候,自动取消所有订阅事件
///
/// 1.b: 使用存储属性`private var eventDispose: JJEventDispose?`,将在生命周期消失的时候,自动取消订阅事件
///
/// 2: 手动取消观察事件
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
public final class JJEventDispose {
    private var eventBusReceiver: JJEventBusReceiverDSL?
    internal init(eventBusReceiver: JJEventBusReceiverDSL) {
        self.eventBusReceiver = eventBusReceiver
    }
}

public extension JJEventDispose {
    /// 添加至自动订阅清除包
    func dispose(by bag: JJEventDisposeBag) {
        bag.insert(self)
    }
    
    /// 手动清除订阅事件
    func dispose() {
        eventBusReceiver = nil
    }
}
