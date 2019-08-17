import UIKit

final public class AlertPresentationController: UIPresentationController {
    public init(show presentedViewController: UIViewController, from presentingViewController: UIViewController?, config configContext: ((AlertPresentationContext) -> ())? = nil) {
        self.context = AlertPresentationContext()
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
        configContext?(context)
    }
    public override var presentedView: UIView? {
        return presentationWrappingView
    }
    private let context: AlertPresentationContext
    private var belowCoverView: UIView?
    private var presentationWrappingView: UIView?
}

// MARK: - Life cycle
extension AlertPresentationController {
    public override func presentationTransitionWillBegin() {
        do {
            guard let presentedViewControllerView = super.presentedView else { return }
            presentedViewControllerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            let f = frameOfPresentedViewInContainerView
            if let warps = context.presentationWrappingView?(presentedViewControllerView, f) {
                self.presentationWrappingView = warps
            } else {
                presentedViewControllerView.frame = f
                self.presentationWrappingView = presentedViewControllerView
            }
        }
        do {
            guard let cb = context.belowCoverView,
            let cv = containerView else { return }
            let bcv = cb(cv.bounds)
            if context.touchedCorverDismiss {
                bcv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(belowCoverTapped(_:))))
            }
            belowCoverView = bcv
            cv.addSubview(bcv)
            guard let coor = presentingViewController.transitionCoordinator else { return }
            context.willPresentAnimatorForBelowCoverView?(bcv, coor)
        }
    }
    
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            presentationWrappingView = nil
            belowCoverView = nil
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        guard let belowView = belowCoverView,
        let coordinator = presentingViewController.transitionCoordinator else { return }
        context.willDismissAnimatorForBelowCoverView?(belowView, coordinator)
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            presentationWrappingView = nil
            belowCoverView = nil
        }
    }
}

// MARK: - Layout
extension AlertPresentationController {
    public override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        if let vc = container as? UIViewController, vc == presentedViewController {
            containerView?.setNeedsLayout()
        }
    }
    
    public override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if let vc = container as? UIViewController, vc == presentedViewController {
            return vc.preferredContentSize
        }
        return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let cv = containerView else {
            return .zero
        }
        let s = size(forChildContentContainer: presentedViewController, withParentContainerSize: cv.bounds.size)
        return context.frameOfPresentedViewInContainerView?(cv.bounds, s) ?? CGRect(origin: .zero, size: s)
    }
    
    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        if let cv = containerView {
            belowCoverView?.frame = cv.bounds
            presentationWrappingView?.frame = frameOfPresentedViewInContainerView
        }
    }
}

extension AlertPresentationController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        assert(presented == presentedViewController, "presentedViewController设置错误")
        return self
    }
}

extension AlertPresentationController: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return context.duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        let cv = transitionContext.containerView
        let isPresenting = presentingViewController == fromVC
        let aniView: UIView
        if isPresenting {
            aniView = transitionContext.view(forKey: .to) ?? toVC.view!
        } else {
            aniView = transitionContext.view(forKey: .from) ?? fromVC.view!
        }
        if isPresenting {
            cv.addSubview(aniView)
        }
        let t  = transitionDuration(using: transitionContext)
        if isPresenting {
            context.transitionAnimator?(aniView, .present(final: transitionContext.finalFrame(for: toVC)), t, transitionContext)
        } else {
            context.transitionAnimator?(aniView, .dismiss(initial: aniView.frame), t, transitionContext)
        }
    }
}

extension AlertPresentationController {
    @IBAction private func belowCoverTapped(_ sender: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
