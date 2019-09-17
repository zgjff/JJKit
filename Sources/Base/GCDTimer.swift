import Foundation

final public class GCDTimer {
    private enum State {
        case suspended, resumed
    }
    
    public init(repeating: TimeInterval, block: @escaping (GCDTimer) -> ()) {
        self.timer = DispatchSource.makeTimerSource(queue: timeQueue)
        timer?.schedule(deadline: .now(), repeating: repeating)
        timer?.setEventHandler {
            block(self)
        }
    }
    
    private var state: State = .suspended
    private var timer: DispatchSourceTimer?
    private let timeQueue = DispatchQueue(label: "com.DispatchSource.JJGCDTimer", attributes: .concurrent)
    
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
    
    public func resume(after seconds: TimeInterval = 0) {
        guard timer != nil else { return }
        guard state != .resumed else { return }
        if seconds == 0 {
            timer?.resume()
            state = .resumed
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
            if self?.timer == nil || self?.state == .resumed { // 为了防止在等待seconds期间,timer被提前释放
                return
            }
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
