//
//  JJPushPopStylePresentDelegate.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

/// 提供使present/dismiss动画跟系统push/pop动画一致的转场动画
public protocol JJPushPopStylePresentDelegate: UIViewController {
    var pushPopStylePresentDelegate: JJPushPopPresentTransitionDelegate { get }
}

private var pushPopStylePresentDelegateKey: Void?

extension JJPushPopStylePresentDelegate {
    /// PushPopStylePresentDelegate属性
    public var pushPopStylePresentDelegate: JJPushPopPresentTransitionDelegate {
        get {
            if let associated = objc_getAssociatedObject(self, &pushPopStylePresentDelegateKey) as? JJPushPopPresentTransitionDelegate { return associated }
            let associated = JJPushPopPresentTransitionDelegate()
            objc_setAssociatedObject(self, &pushPopStylePresentDelegateKey, associated, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return associated
        }
        set {
            objc_setAssociatedObject(self, &pushPopStylePresentDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIViewController: JJCompatible {}

extension JJBox where Base: JJPushPopStylePresentDelegate {
    /// 添加跟系统pop一样的动画的手势dismiss
    public func addScreenPanGestureDismiss() {
        base.addScreenPanGestureDismiss()
    }
    
    /// 开始跟系统pop一样的动画的dismiss
    /// - Parameters:
    ///   - gesture: UIScreenEdgePanGestureRecognizer手势
    ///   - animated: 是否动画
    ///   - completion: 回调
    public func popStyleDismiss(with gesture: UIScreenEdgePanGestureRecognizer? = nil, animated: Bool = true, completion: (()-> ())?) {
        if let navit = base.navigationController?.transitioningDelegate as? JJPushPopPresentTransitionDelegate {
            navit.targetEdge = .left
            navit.gestureRecognizer = gesture
            base.navigationController?.dismiss(animated: animated, completion: completion)
            return
        }
        if let t = base.transitioningDelegate as? JJPushPopPresentTransitionDelegate {
            t.targetEdge = .left
            t.gestureRecognizer = gesture
            base.dismiss(animated: animated, completion: completion)
            return
        }
        base.dismiss(animated: animated, completion: completion)
    }
}

extension JJPushPopStylePresentDelegate {
    /// 添加跟系统pop一样的动画的dismiss
    fileprivate func addScreenPanGestureDismiss() {
        let spGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(onBeganEdgePanGestureBack(_:)))
        spGesture.edges = .left
        view.addGestureRecognizer(spGesture)
    }
}

extension UIViewController {
    @IBAction fileprivate func onBeganEdgePanGestureBack(_ sender: UIScreenEdgePanGestureRecognizer) {
        guard case .began = sender.state else {
            return
        }
        if let navit = navigationController?.transitioningDelegate as? JJPushPopPresentTransitionDelegate {
            navit.targetEdge = .left
            navit.gestureRecognizer = sender
            navigationController?.dismiss(animated: true, completion: nil)
            return
        }
        if let t = transitioningDelegate as? JJPushPopPresentTransitionDelegate {
            t.targetEdge = .left
            t.gestureRecognizer = sender
            dismiss(animated: true, completion: nil)
            return
        }
        dismiss(animated: true, completion: nil)
    }
}
