//
//  JJPushPopPresentAnimator.swift
//  JJKit
//
//  Created by 郑桂杰 on 2022/9/30.
//

import UIKit

internal final class JJPushPopPresentAnimator: NSObject {
    var transitionCompleted: (() -> ())?
    init(edge: UIRectEdge) {
        self.targetEdge = edge
        super.init()
    }
    private let targetEdge: UIRectEdge
}

extension JJPushPopPresentAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return (transitionContext?.isAnimated ?? true) ? 0.35 : 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        // FIX: - pageSheet
        if fromVC.modalPresentationStyle == .custom || toVC.modalPresentationStyle == .custom || fromVC.modalPresentationStyle == .pageSheet || toVC.modalPresentationStyle == .pageSheet {
            return customModalPresentationStyleAnimateTransition(using: transitionContext)
        } else {
            return systemModalPresentationStyleAnimateTransition(using: transitionContext)
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        self.transitionCompleted?()
    }
}

private extension JJPushPopPresentAnimator {
    func systemModalPresentationStyleAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        let duration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        var fromView, toView: UIView
        if transitionContext.responds(to: #selector(transitionContext.view(forKey:))) {
            fromView = transitionContext.view(forKey: .from) ?? fromVC.view!
            toView = transitionContext.view(forKey: .to) ?? toVC.view!
        } else {
            fromView = fromVC.view
            toView = toVC.view
        }
        
        let isPresenting = toVC.presentingViewController == fromVC
        
        let startFrame = transitionContext.initialFrame(for: fromVC)
        let endFrame = transitionContext.finalFrame(for: toVC)
        print(fromVC.modalPresentationStyle.rawValue, toVC.modalPresentationStyle.rawValue)
        var offset: CGVector
        switch targetEdge {
        case .top:
            offset = CGVector(dx: 0, dy: 1)
        case .bottom:
            offset = CGVector(dx: 0, dy: -1)
        case .left:
            offset = CGVector(dx: 1, dy: 0)
        case .right:
            offset = CGVector(dx: -1, dy: 0)
        default:
            offset = CGVector()
            assert(false, "targetEdge must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.")
        }
        
        if isPresenting {
            fromView.frame = startFrame
            toView.frame = endFrame.offsetBy(dx: endFrame.width * offset.dx * -1, dy: endFrame.height * offset.dy * -1)
        } else {
            fromView.frame = startFrame
            toView.frame = endFrame.offsetBy(dx: endFrame.width * -0.3, dy: 0)
        }
        
        if isPresenting {
            toView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            toView.layer.shadowOffset = CGSize(width: -1, height: 1)
            toView.layer.shadowRadius = 1
            toView.layer.shadowOpacity = 1
            toView.layer.shadowPath = UIBezierPath(rect: toView.bounds).cgPath
            toView.clipsToBounds = false
        } else {
            fromView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
            fromView.layer.shadowOffset = CGSize(width: -1, height: 1)
            fromView.layer.shadowRadius = 1
            fromView.layer.shadowOpacity = 1
            fromView.layer.shadowPath = UIBezierPath(rect: toView.bounds).cgPath
            fromView.clipsToBounds = false
        }
        
        if isPresenting {
            containerView.addSubview(toView)
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
        }
        if !transitionContext.isInteractive {
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
                if isPresenting {
                    toView.frame = endFrame
                    fromView.frame = startFrame.offsetBy(dx: startFrame.width * -0.3, dy: 0)
                } else {
                    fromView.frame = startFrame.offsetBy(dx: startFrame.width * offset.dx, dy: startFrame.height * offset.dy)
                    toView.frame = endFrame
                }
            } completion: { _ in
                let wasCancelled = transitionContext.transitionWasCancelled
                if wasCancelled {
                    toView.removeFromSuperview()
                }
                transitionContext.completeTransition(!wasCancelled)
            }
            return
        }
        UIView.animate(withDuration: duration, animations: {
            if isPresenting {
                toView.frame = endFrame
                fromView.frame = startFrame.offsetBy(dx: startFrame.width * -0.3, dy: 0)
            } else {
                fromView.frame = startFrame.offsetBy(dx: startFrame.width * offset.dx, dy: startFrame.height * offset.dy)
                toView.frame = endFrame
            }
        }) { _ in
            let wasCancelled = transitionContext.transitionWasCancelled
            if wasCancelled {
                toView.removeFromSuperview()
            }
            transitionContext.completeTransition(!wasCancelled)
        }
    }
    
    func customModalPresentationStyleAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        let duration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        var fromView, toView: UIView
        if transitionContext.responds(to: #selector(transitionContext.view(forKey:))) {
            //TODO: 适配iOS13
            fromView = transitionContext.view(forKey: .from) ?? fromVC.view!
            toView = transitionContext.view(forKey: .to) ?? toVC.view!
        } else {
            fromView = fromVC.view
            toView = toVC.view
        }
        
        let isPresenting = toVC.presentingViewController == fromVC
        
        let startFrame = fromVC.presentationController?.frameOfPresentedViewInContainerView ?? transitionContext.initialFrame(for: fromVC)
        let endFrame = toVC.presentationController?.frameOfPresentedViewInContainerView ?? transitionContext.finalFrame(for: toVC)
        
        var offset: CGVector
        switch targetEdge {
        case .top:
            offset = CGVector(dx: 0, dy: 1)
        case .bottom:
            offset = CGVector(dx: 0, dy: -1)
        case .left:
            offset = CGVector(dx: 1, dy: 0)
        case .right:
            offset = CGVector(dx: -1, dy: 0)
        default:
            offset = CGVector()
            assert(false, "targetEdge must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.")
        }
        
        if isPresenting {
            toView.frame = endFrame.offsetBy(dx: endFrame.width * offset.dx * -1, dy: endFrame.height * offset.dy * -1)
        } else {
            fromView.frame = startFrame
        }
        if isPresenting {
            containerView.addSubview(toView)
        }
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            if isPresenting {
                toView.frame = endFrame
            } else {
                fromView.frame = startFrame.offsetBy(dx: startFrame.width * offset.dx, dy: startFrame.height * offset.dy)
            }
        } completion: { _ in
            let wasCancelled = transitionContext.transitionWasCancelled
            if wasCancelled {
                toView.removeFromSuperview()
            }
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}
