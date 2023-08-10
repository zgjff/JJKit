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
    func showToast(inView view: UIView, animated: Bool)
    /// 隐藏toast
    func beginHidden(animated: Bool)
    /// 在一定时间之后执行自动隐藏
    func performAutoHidden(after delay: TimeInterval)
    /// 取消自动隐藏
    func cancelPerformAutoHidden()
}

extension JJToastContainer {
    public func showToast(inView view: UIView, animated: Bool) {
        self.center = options.postition.centerForContainer(self, inView: view)
        layer.jj.setCornerRadius(options.cornerRadius, corner: options.corners)
        clipsToBounds = true
        view.addSubview(self)
        shownContaienrQueue.append(self)
        options.onAppear?()
        var needAnimation = false
        if animated, let ani = options.startAppearAnimations(for: self) {
            needAnimation = true
            let key = options.layerAnimationKey(forShow: true)
            layer.add(ani, forKey: key)
        }
        if case let .seconds(t) = options.duration, needAnimation {
            performAutoHidden(after: t + options.showOrHiddenAnimationDuration)
        }
    }
    
    public func beginHidden(animated: Bool = true) {
        cancelPerformAutoHidden()
        layer.removeAllAnimations()
        if animated, let ani = options.startHiddenAnimations(for: self) {
            ani.delegate = JJWeakProxy(target: self).target
            let key = options.layerAnimationKey(forShow: false)
            layer.add(ani, forKey: key)
            return
        }
        remove()
    }
    
    internal func remove() {
        let sv = superview
        removeFromSuperview()
        options.onDisappear?()
        sv?.shownContaienrQueue.remove(self)
    }
}
