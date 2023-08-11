//
//  JJGradientContainer.swift
//  Demo
//
//  Created by zgjff on 2023/8/10.
//

import UIKit

/// 带渐变色的容器默认实现
public final class JJGradientContainer: UIView, CAAnimationDelegate {
    public var options = JJToastContainerOptions()
    public var state = JJToastState.presenting
    public private(set) var toastItem: (any JJToastItemable)?
    private var orientationObserver: NSObjectProtocol?
    private lazy var gradientLayer = CAGradientLayer()
    init(colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint = CGPoint(x: 0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1, y: 0.5)) {
        super.init(frame: .zero)
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
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
        handleAnimationDidStop(anim, finished: flag)
    }
}

// MARK: - JJToastContainer
extension JJGradientContainer: JJToastContainer {
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
extension JJGradientContainer {
    public func didCalculationView(_ view: UIView, viewSize size: CGSize, sender: any JJToastItemable) {
        toastItem = sender
        bounds.size = size
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        if view.superview == nil {
            addSubview(view)
        }
        if let sv = superview {
            self.center = options.postition.centerForContainer(self, inView: sv)
        }
    }
}
