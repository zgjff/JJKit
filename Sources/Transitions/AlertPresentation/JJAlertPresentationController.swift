//
//  JJAlertPresentationController.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

/// 弹窗驱动提供器,方便自定义弹窗弹出动画逻辑
final public class JJAlertPresentationController: UIPresentationController {
    /// 初始化弹窗驱动提供器
    /// - Parameters:
    ///   - presentedViewController: 跳转源控制器
    ///   - presentingViewController: 跳转目标控制器
    ///   - configContext: 设置context的block
    public init(show presentedViewController: UIViewController, from presentingViewController: UIViewController?, config configContext: ((_ ctx: JJAlertPresentationContext) -> ())? = nil) {
        self.context = JJAlertPresentationContext()
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
        presentedViewController.transitioningDelegate = self
        configContext?(context)
    }
    public override var presentedView: UIView? {
        return presentationWrappingView
    }
    private let context: JJAlertPresentationContext
    private var belowCoverView: UIView?
    private var presentationWrappingView: UIView?
}

// MARK: - public
extension JJAlertPresentationController {
    /// 更新动画协调器
    public func updateContext(_ block: (_ ctx: JJAlertPresentationContext) -> ()) {
        block(context)
    }
    
    /// 开始present跳转
    /// - Parameters:
    ///   - animated: 动画与否
    ///   - completion: 跳转完成回调
    public func startPresent(animated: Bool = true, completion: (() -> ())?) {
        presentingViewController.present(presentedViewController, animated: animated) {
            let _ = self
            completion?()
        }
    }
}

// MARK: - Life cycle
extension JJAlertPresentationController {
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
        if context.presentingControllerTriggerAppearLifecycle.contains(.disappear) {
            presentingViewController.beginAppearanceTransition(false, animated: true)
        }
        do {
            guard let cb = context.belowCoverView,
            let cv = containerView else { return }
            let bcv = cb(cv.bounds)
            bcv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(belowCoverTapped(_:))))
            belowCoverView = bcv
            cv.addSubview(bcv)
            guard let coor = presentingViewController.transitionCoordinator else { return }
            context.willPresentAnimatorForBelowCoverView?(bcv, coor)
        }
    }
    
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        if (completed) {
            if context.presentingControllerTriggerAppearLifecycle.contains(.disappear) {
                presentingViewController.endAppearanceTransition()
            }
        }
        if !completed {
            presentationWrappingView = nil
            belowCoverView = nil
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        guard let belowView = belowCoverView,
        let coordinator = presentingViewController.transitionCoordinator else { return }
        if context.presentingControllerTriggerAppearLifecycle.contains(.appear) {
            presentingViewController.beginAppearanceTransition(true, animated: true)
        }
        context.willDismissAnimatorForBelowCoverView?(belowView, coordinator)
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            presentationWrappingView = nil
            belowCoverView = nil
            if context.presentingControllerTriggerAppearLifecycle.contains(.appear) {
                presentingViewController.endAppearanceTransition()
            }
        }
    }
}

// MARK: - Layout
extension JJAlertPresentationController {
    public override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        guard let vc = container as? UIViewController, vc == presentedViewController else {
            return
        }
        containerView?.setNeedsLayout()
        guard let config = context.preferredContentSizeDidChangeAnimationInfo else {
            containerView?.layoutIfNeeded()
            return
        }
        UIView.animate(withDuration: config.duration, delay: config.delay, options: config.options) {
            self.containerView?.layoutIfNeeded()
        } completion: { _ in
            
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

// MARK: - UIViewControllerTransitioningDelegate
extension JJAlertPresentationController: UIViewControllerTransitioningDelegate {
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

// MARK: - UIViewControllerAnimatedTransitioning
extension JJAlertPresentationController: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if let ctx = transitionContext {
            return ctx.isAnimated ? context.duration : 0
        }
        return context.duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        let cv = transitionContext.containerView
        let isPresenting = presentingViewController == fromVC
        let fromView = transitionContext.view(forKey: .from) ?? fromVC.view!
        let toView = transitionContext.view(forKey: .to) ?? toVC.view!
        
        let finitialFrame = transitionContext.initialFrame(for: fromVC)
        let ffinalFrame = transitionContext.finalFrame(for: fromVC)
        let tinitialFrame = transitionContext.initialFrame(for: toVC)
        let tfinalFrame = transitionContext.finalFrame(for: toVC)
        
        let framesInfo = JJAlertPresentationContext.TransitionContextFrames.init(fromInitialFrame: finitialFrame, fromFinalFrame: ffinalFrame, toInitialFrame: tinitialFrame, toFinalFrame: tfinalFrame)
        
        if isPresenting {
            cv.addSubview(toView)
        }
        let t  = transitionDuration(using: transitionContext)
        if isPresenting {
            context.transitionAnimator?(fromView, toView, .present(frames: framesInfo), t, transitionContext)
        } else {
            context.transitionAnimator?(fromView, toView, .dismiss(frames: framesInfo), t, transitionContext)
        }
    }
}

// MARK: - private
private extension JJAlertPresentationController {
    @IBAction func belowCoverTapped(_ sender: UITapGestureRecognizer) {
        switch context.belowCoverAction {
        case .autodismiss(let isDismiss):
            if isDismiss {
                presentingViewController.dismiss(animated: true, completion: nil)
            }
        case .customize(action: let block):
            block()
        }
    }
}
