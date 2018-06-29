//
//  GCDTimer.swift
//  Demo
//
//  Created by 郑桂杰 on 2018/5/8.
//  Copyright © 2018年 郑桂杰. All rights reserved.
//

import Foundation

final public class GCDTimer {
    private enum State {
        case suspended, resumed
    }
    
    public init(repeating: Double, block: @escaping (GCDTimer) -> ()) {
        self.timer = DispatchSource.makeTimerSource(queue: timeQueue)
        timer?.schedule(deadline: .now(), repeating: repeating)
        timer?.setEventHandler {
            block(self)
        }
    }
    
    private var state: State = .suspended
    private var timer: DispatchSourceTimer?
    private let timeQueue = DispatchQueue(label: "com.DispatchSource.timer", attributes: .concurrent)
    
    deinit {
        cancel()
    }
}

extension GCDTimer {
    public func suspend() {
        guard let timer = timer else { return }
        guard state != .suspended else { return }
        timer.suspend()
        state = .suspended
    }
    
    public func resume(after seconds: Double = 0) {
        guard timer != nil else { return }
        guard state != .resumed else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
            self?.timer?.resume()
            self?.state = .resumed
        }
    }
    
    public func cancel() {
        guard let timer = timer else { return }
        if case .suspended = state {
            timer.setEventHandler(handler: nil)
            timer.resume()
        }
        timer.cancel()
        state = .suspended
        self.timer = nil
    }
}
