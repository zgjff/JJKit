//
//  JJToastContainer.swift
//  JJToast
//
//  Created by zgjff on 2023/8/8.
//

import UIKit

/// `toast`容器协议
public protocol JJToastContainer: UIView, JJToastableDelegate, CAAnimationDelegate {
    /// 配置
    var options: JJToastContainerOptions { get set }
    /// 状态
    var state: JJToastState { get set }
    /// 具体承载的`toast`样式
    var toastItem: (any JJToastItemable)? { get }
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
    /// 移除
    func remove()
}

private let JJ_Toast_AnimationKey = "jj_toast__animator_key"

extension JJToastContainer {
    public func present(_ viewToShow: UIView, animated flag: Bool) {
        if let toastItem {
            toastItem.options.sameToastItemTypeStrategy.toatContainer(self, willPresentIn: viewToShow, animated: flag)
        }
    }
    
    public func dismiss(animated flag: Bool = true) {
        if state == .dismissing {
            if flag { // 正在动画,并且要动画dismiss,直接返回
                return
            } else { // 正在动画,并且要不动画dismiss,直接隐藏
                remove()
                return
            }
        }
        state = .dismissing
        cancelperformAutoDismiss()
        layer.removeAllAnimations()
        if flag, let ani = options.startHiddenAnimations(for: self) {
            ani.delegate = JJWeakProxy(target: self).target
            let key = options.layerAnimationKey(forShow: false)
            ani.setValue(key, forKey: JJ_Toast_AnimationKey)
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
    
    public func remove() {
        let sv = superview
        removeFromSuperview()
        options.onDisappear?()
        state = .dismissed
        sv?.shownContaienrQueue.remove(self)
    }
}

extension JJToastContainer {
    /// 处理显示`toast`逻辑
    /// - Parameters:
    ///   - viewToShow: 显示`toast`的`view`
    ///   - flag: 显示动画标志
    public func dealShow(in viewToShow: UIView, animated flag: Bool) {
        cancelperformAutoDismiss()
        state = .presenting
        self.center = options.postition.centerForContainer(self, inView: viewToShow)
        switch options.cornerRadius {
        case .fix(let f):
            layer.jj.setCornerRadius(f, corner: options.corners)
        case .halfHeight:
            layer.jj.setCornerRadius(bounds.height * 0.5, corner: options.corners)
        }
        clipsToBounds = true
        viewToShow.addSubview(self)
        viewToShow.shownContaienrQueue.append(self)
        options.onAppear?()
        var needAnimation = false
        if flag, let ani = options.startAppearAnimations(for: self) {
            ani.delegate = JJWeakProxy(target: self).target
            needAnimation = true
            let key = options.layerAnimationKey(forShow: true)
            ani.setValue(key, forKey: JJ_Toast_AnimationKey)
            layer.add(ani, forKey: key)
        } else {
            state = .presented
        }
        if case let .seconds(t) = options.duration  {
            performAutoDismiss(after: needAnimation ? (t + options.showOrHiddenAnimationDuration) : t)
        }
    }
    
    /// 处理动画结束逻辑
    public func handleAnimationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        layer.removeAllAnimations()
        guard let name = anim.value(forKey: JJ_Toast_AnimationKey) as? String else {
            return
        }
        switch name {
        case JJToastContainerOptions.layerShowAnimationKey: //显示
            state = .presented
        case JJToastContainerOptions.layerDismissAnimationKey: // 隐藏
            remove()
        default:
            return
        }
    }
}
