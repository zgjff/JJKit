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
    private var toastItem: (any JJToastItemable)?
    private var orientationObserver: NSObjectProtocol?
    private var isPortraitOrientation = UIApplication.shared.jj.orientation.isPortrait {
        didSet {
            if isPortraitOrientation != oldValue {
                DispatchQueue.main.async { [weak self] in
                    if let self, let v = self.superview {
                        self.toastItem?.resetContentSizeWithViewSize(v.bounds.size)
                    }
                }
            }
        }
    }
    
    public override init(effect: UIVisualEffect?) {
        let eff = effect == nil ? UIBlurEffect(style: .dark) : effect
        super.init(effect: eff)
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        orientationObserver = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.isPortraitOrientation = UIApplication.shared.jj.orientation.isPortrait
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("BlurEffectContainer deinit")
        if let orientationObserver = orientationObserver {
            NotificationCenter.default.removeObserver(orientationObserver)
        }
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
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
extension JJBlurEffectContainer: JJToastContainer {
    public func performAutoHidden(after delay: TimeInterval) {
        perform(#selector(needHiddenToast), with: nil, afterDelay: delay)
    }
    
    public func cancelPerformAutoHidden() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(needHiddenToast), object: nil)
    }
    
    @IBAction private func needHiddenToast() {
        beginHidden(animated: true)
    }
}

// MARK: - JJToastableDelegate
extension JJBlurEffectContainer {
    public func didCalculationView(_ view: UIView, viewSize size: CGSize, sender: any JJToastItemable) {
        toastItem = sender
        bounds.size = size
        if view.superview == nil {
            contentView.addSubview(view)
        }
        if let sv = superview {
            self.center = options.postition.centerForContainer(self, inView: sv)
        }
    }
}
