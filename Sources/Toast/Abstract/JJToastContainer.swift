//
//  JJToastContainer.swift
//  JJKit
//
//  Created by zgjff on 2023/8/8.
//

import UIKit

/// `toast`容器协议
public protocol JJToastContainer: UIView, JJToastableDelegate, CAAnimationDelegate {
    var options: JJToastContainerOptions { get set }
    /// 显示toast
    func present(_ viewToShow: UIView, animated flag: Bool)
    /// 隐藏toast
    func dismiss(animated flag: Bool)
    /// 在一定时间之后执行自动隐藏
    func performAutoDismiss(after delay: TimeInterval)
    /// 取消自动隐藏
    func cancelperformAutoDismiss()
    /// 观察屏幕方向改变
    func addOrientationDidChangeObserver(action: @escaping (CGSize) -> ()) -> NSObjectProtocol?
    /// 取消屏幕方向观察
    func removeOrientationDidChangeObserver(_ observer: NSObjectProtocol?)
}

extension JJToastContainer {
    public func present(_ viewToShow: UIView, animated flag: Bool) {
        cancelperformAutoDismiss()
        self.center = options.postition.centerForContainer(self, inView: viewToShow)
        layer.jj.setCornerRadius(options.cornerRadius, corner: options.corners)
        clipsToBounds = true
        viewToShow.addSubview(self)
        shownContaienrQueue.append(self)
        options.onAppear?()
        var needAnimation = false
        if flag, let ani = options.startAppearAnimations(for: self) {
            needAnimation = true
            let key = options.layerAnimationKey(forShow: true)
            layer.add(ani, forKey: key)
        }
        if case let .seconds(t) = options.duration, needAnimation {
            performAutoDismiss(after: t + options.showOrHiddenAnimationDuration)
        }
    }
    
    public func dismiss(animated flag: Bool = true) {
        cancelperformAutoDismiss()
        layer.removeAllAnimations()
        if flag, let ani = options.startHiddenAnimations(for: self) {
            ani.delegate = JJWeakProxy(target: self).target
            let key = options.layerAnimationKey(forShow: false)
            layer.add(ani, forKey: key)
            return
        }
        remove()
    }
    
    public func addOrientationDidChangeObserver(action: @escaping (CGSize) -> ()) -> NSObjectProtocol? {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        return NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            DispatchQueue.main.async { [weak self] in
                if let v = self?.superview {
                    action(v.bounds.size)
                }
            }
        }
    }
    
    public func removeOrientationDidChangeObserver(_ observer: NSObjectProtocol?) {
        if let observer {
            NotificationCenter.default.removeObserver(observer)
        }
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
}

extension JJToastContainer {
    internal func remove() {
        let sv = superview
        removeFromSuperview()
        options.onDisappear?()
        sv?.shownContaienrQueue.remove(self)
    }
}
