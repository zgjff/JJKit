import UIKit

public protocol SwipePresentDelegate: NSObjectProtocol {
    var swipePresentDelegate: SwipeTransitionDelegate { get }
}
private var swipePresentDelegateKey: Void?
extension SwipePresentDelegate where Self: UIViewController {
    /// 记得在present之前要更改其 targetEdge= .right
    public var swipePresentDelegate: SwipeTransitionDelegate {
        get {
            return StoreValueManager.get(from: self, key: &swipePresentDelegateKey, initialiser: { () -> SwipeTransitionDelegate in
                return SwipeTransitionDelegate()
            })
        }
        set {
            StoreValueManager.set(for: self, key: &swipePresentDelegateKey, value: newValue)
        }
    }
    public func swipePresent(to vc: UIViewController, gesture withGesture: UIScreenEdgePanGestureRecognizer? = nil) {
        swipePresentDelegate.targetEdge = .right
        swipePresentDelegate.gestureRecognizer = withGesture
        present(vc, animated: true, completion: nil)
    }
}

extension UIViewController: JJCompatible {}
extension JJ where Original: UIViewController {
    public func swipeDismiss(with gesture: UIScreenEdgePanGestureRecognizer? = nil) {
        if let navit = original.navigationController?.transitioningDelegate as? SwipeTransitionDelegate {
            navit.targetEdge = .left
            navit.gestureRecognizer = gesture
            original.navigationController?.dismiss(animated: true, completion: nil)
            return
        }
        if let t = original.transitioningDelegate as? SwipeTransitionDelegate {
            t.targetEdge = .left
            t.gestureRecognizer = gesture
            original.dismiss(animated: true, completion: nil)
            return
        }
        original.dismiss(animated: true, completion: nil)
    }
    public func addLeftSwipeDismiss() {
        let ep = UIScreenEdgePanGestureRecognizer { [unowned self] sender in
            guard case .began = sender.state else {
                return
            }
            self.swipeDismiss()
        }
        ep.edges = .left
        original.view.addGestureRecognizer(ep)
    }
}


public class SwipeTransitionDelegate: NSObject {
    public var gestureRecognizer: UIScreenEdgePanGestureRecognizer?
    public var targetEdge: UIRectEdge = .right
}

extension SwipeTransitionDelegate: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SwipeTransitionAnimator(edge: targetEdge)
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SwipeTransitionAnimator(edge: targetEdge)
    }
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let ges = gestureRecognizer {
            return SwipeDrivenTransition(gestureRecognizer: ges, edgeForDragging: targetEdge)
        } else {
            return nil
        }
    }
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let ges = gestureRecognizer {
            return SwipeDrivenTransition(gestureRecognizer: ges, edgeForDragging: targetEdge)
        } else {
            return nil
        }
    }
}

private final class SwipeDrivenTransition: UIPercentDrivenInteractiveTransition {
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


extension SwipeDrivenTransition {
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

private final class SwipeTransitionAnimator: NSObject {
    init(edge: UIRectEdge) {
        self.targetEdge = edge
        super.init()
    }
    private let targetEdge: UIRectEdge
}

extension SwipeTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        let duration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        var fromView, toView: UIView
        if transitionContext.responds(to: #selector(transitionContext.view(forKey:))) {
            fromView = transitionContext.view(forKey: .from)!
            toView = transitionContext.view(forKey: .to)!
        } else {
            fromView = fromVC.view
            toView = toVC.view
        }
        
        let isPresenting = toVC.presentingViewController == fromVC
        
        let startFrame = transitionContext.initialFrame(for: fromVC)
        let endFrame = transitionContext.finalFrame(for: toVC)
        
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
            toView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
            toView.layer.shadowOffset = CGSize(width: -4, height: 4)
            toView.layer.shadowRadius = 4
            toView.layer.shadowOpacity = 1
            toView.layer.shadowPath = UIBezierPath(rect: toView.bounds).cgPath
        } else {
            fromView.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
            fromView.layer.shadowOffset = CGSize(width: -4, height: 4)
            fromView.layer.shadowRadius = 4
            fromView.layer.shadowOpacity = 1
            fromView.layer.shadowPath = UIBezierPath(rect: fromView.bounds).cgPath
        }
        
        if isPresenting {
            containerView.addSubview(toView)
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
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
}
