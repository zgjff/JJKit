//
//  JJBlurEffectContainer.swift
//  JJKit
//
//  Created by zgjff on 2023/8/8.
//

import UIKit

/// 高斯模糊容器
public final class JJBlurEffectContainer: UIVisualEffectView, CAAnimationDelegate {
    public var options = JJToastContainerOptions()
    public var state = JJToastState.presenting
    public private(set) var toastItem: (any JJToastItemable)?
    private var orientationObserver: NSObjectProtocol?
    
    public override init(effect: UIVisualEffect?) {
        let eff = effect == nil ? UIBlurEffect(style: .dark) : effect
        super.init(effect: eff)
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)
        orientationObserver = addOrientationDidChangeObserver(action: { [weak self] size in
            self?.toastItem?.resetContentSizeWithViewSize(size)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeOrientationDidChangeObserver(orientationObserver)
    }
    
    @IBAction private func onTap() {
        options.onTap?(self)
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        handleAnimationDidStop(anim, finished: flag)
    }
}

// MARK: - JJToastContainer
extension JJBlurEffectContainer: JJToastContainer {
    public func performAutoDismiss(after delay: TimeInterval) {
        perform(#selector(needHiddenToast), with: nil, afterDelay: delay)
    }
    
    public func cancelperformAutoDismiss() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(needHiddenToast), object: nil)
    }
    
    @IBAction private func needHiddenToast() {
        dismiss()
    }
}

// MARK: - JJToastableDelegate
extension JJBlurEffectContainer {
    public func didCalculationView(_ view: UIView, viewSize size: CGSize, sender: any JJToastItemable) {
        bounds.size = size
        if view.superview == nil { // 第一次添加
            toastItem = sender
            contentView.addSubview(view)
            return
        }
        if let sv = superview {
            self.center = options.postition.centerForContainer(self, inView: sv)
        }
    }
    
    public func triggerAutoDismiss(sender: any JJToastItemable, animated flag: Bool) {
        dismiss(animated: flag)
    }
}
