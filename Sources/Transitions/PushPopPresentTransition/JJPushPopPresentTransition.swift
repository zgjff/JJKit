//
//  JJPushPopPresentTransition.swift
//  JJKit
//
//  Created by 郑桂杰 on 2022/9/30.
//

import UIKit

internal final class JJPushPopPresentTransition: UIPercentDrivenInteractiveTransition {
    init(gestureRecognizer: UIScreenEdgePanGestureRecognizer, edgeForDragging edge: UIRectEdge) {
        assert(edge == .top || edge == .bottom || edge == .left || edge == .right, "targetEdge must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.")
        self.gestureRecognizer = gestureRecognizer
        self.edge = edge
        super.init()
        gestureRecognizer.addTarget(self, action: #selector(gestureRecongnizeDidUpdate(_:)))
    }
    
    private let gestureRecognizer: UIScreenEdgePanGestureRecognizer
    private let edge: UIRectEdge
    private weak var transitionContext: UIViewControllerContextTransitioning?
    deinit {
        gestureRecognizer.removeTarget(self, action: #selector(gestureRecongnizeDidUpdate(_:)))
    }
}


extension JJPushPopPresentTransition {
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
    }
    
    @IBAction private func gestureRecongnizeDidUpdate(_ sender: UIScreenEdgePanGestureRecognizer) {
        switch sender.state {
        case .began:
            return
        case .changed:
            update(percentForGesture(sender))
        case .ended:
            if percentForGesture(sender) >= 0.5 {
                finish()
            } else {
                cancel()
            }
        default:
            cancel()
        }
    }
    
    private func percentForGesture(_ sender: UIScreenEdgePanGestureRecognizer) -> CGFloat {
        guard let transitionContainerView = transitionContext?.containerView else { return 0 }
        let location = sender.location(in: transitionContainerView)
        
        let width = transitionContainerView.bounds.width
        let height = transitionContainerView.bounds.height
        
        switch edge {
        case .right:
            return (width - location.x) / width
        case .left:
            return location.x / width
        case .bottom:
            return (height - location.y) / height
        case .top:
            return location.y / height
        default:
            return 0
        }
    }
}
