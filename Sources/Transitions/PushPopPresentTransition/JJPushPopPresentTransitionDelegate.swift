//
//  JJPushPopPresentTransitionDelegate.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

public class JJPushPopPresentTransitionDelegate: NSObject {
    public var gestureRecognizer: UIScreenEdgePanGestureRecognizer?
    public var targetEdge: UIRectEdge = .right
}

extension JJPushPopPresentTransitionDelegate: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = JJPushPopPresentAnimator(edge: targetEdge)
        animator.transitionCompleted = { [weak self] in
            self?.targetEdge = .left
        }
        return animator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = JJPushPopPresentAnimator(edge: targetEdge)
        animator.transitionCompleted = { [weak self] in
            self?.targetEdge = .left
        }
        return animator
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let ges = gestureRecognizer {
            return JJPushPopPresentTransition(gestureRecognizer: ges, edgeForDragging: targetEdge)
        } else {
            return nil
        }
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let ges = gestureRecognizer {
            return JJPushPopPresentTransition(gestureRecognizer: ges, edgeForDragging: targetEdge)
        } else {
            return nil
        }
    }
}
