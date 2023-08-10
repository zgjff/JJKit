//
//  JJColorfulContainer.swift
//  Demo
//
//  Created by zgjff on 2023/8/10.
//

import UIKit

/// 带背景色的容器默认实现
public final class JJColorfulContainer: UIView, CAAnimationDelegate {
    public var options = JJToastContainerOptions()
    private var toastItem: (any JJToastItemable)?
    private var orientationObserver: NSObjectProtocol?
    init(color: UIColor) {
        super.init(frame: .zero)
        backgroundColor = color
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
        debugPrint("JJColorfulContainer deinit")
        removeOrientationDidChangeObserver(orientationObserver)
    }
    
    @IBAction private func onTap() {
        options.onTap?(self)
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        layer.removeAllAnimations()
        remove()
    }
}

// MARK: - JJToastContainer
extension JJColorfulContainer: JJToastContainer {
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
extension JJColorfulContainer {
    public func didCalculationView(_ view: UIView, viewSize size: CGSize, sender: any JJToastItemable) {
        toastItem = sender
        bounds.size = size
        if view.superview == nil {
            addSubview(view)
        }
        if let sv = superview {
            self.center = options.postition.centerForContainer(self, inView: sv)
        }
    }
}