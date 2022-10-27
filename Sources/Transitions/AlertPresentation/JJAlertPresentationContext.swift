//
//  JJAlertPresentationContext.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

/// 弹窗驱动上下文
final public class JJAlertPresentationContext {
    /// 转场动画持续时间---默认0.2s
    public var duration: TimeInterval = 0.2
    
    /// 源控制器是否触发生命周期(viewWillDisappear/viewDidDisappear/viewWillAppear/viewDidAppear),默认不触发任何
    public var presentingControllerTriggerAppearLifecycle = TriggerPresentingControllerLifecycle.none
    
    /// 弹出界面的其余部分点击事件,默认为自动dismiss
    ///
    /// 可以在弹窗出现之后通过`AlertPresentationController`的`updateContext`方法随时更改此属性
    ///
    /// eg:可以在弹窗展示的时候为`.autodismiss(false)`,然后,在页面事件处理完成之后改为`.autodismiss(true)`
    ///
    /// 同时,默认的点击空白消失是带动画的.如果不想带动画,请设置为`.customize`,在block内部手动调用dismiss
    public var belowCoverAction = JJAlertPresentationContext.BelowCoverAction.autodismiss(true)
    
    /// preferredContentSize 改变时的动画配置, 默认为nil
    public var preferredContentSizeDidChangeAnimationInfo: (duration: TimeInterval, delay: TimeInterval, options: UIView.AnimationOptions)?
    
    /// 转场动画中presentingViewController的View的frame----默认frame可以使presentingView居中
    public var frameOfPresentedViewInContainerView: ((_ containerViewBounds: CGRect, _ preferredContentSize: CGSize) -> (CGRect))? = Default.centerFrameOfPresentedView
    
    /// presentingViewController的view修饰view----默认4个圆角带阴影view
    public var presentationWrappingView: ((_ presentedViewControllerView: UIView, _ frameOfPresentedView: CGRect) -> UIView)? = Default.shadowAllRoundedCornerWrappingView(10)
    
    /// presentingViewController的view底部封面view,默认是暗灰色view
    ///
    /// 一般是暗灰色的view或者UIVisualEffectView,同时将autoresizingMask设置成[.flexibleWidth, .flexibleHeight];
    ///
    ///  在转场动画时,可以做动画效果
    /// - 例如:UIVisualEffectView可以在presentationTransitionWillBegin动画时间里,将effect从nil,设置成UIBlurEffect(style: .extraLight)
    ///       并在dismissalTransitionWillBegin动画时间里,将effect设置成nil
    /// - 暗灰色的view:可以在presentationTransitionWillBegin动画时间里,将alpha从0.0,设置成0.5
    ///       并在dismissalTransitionWillBegin动画时间里,将alpha设置成0.0
    public var belowCoverView: ((_ frame: CGRect) -> UIView)? = Default.dimmingBelowCoverView
    
    /// 转场动画的具体实现----默认是弹出居中view的动画效果
    public var transitionAnimator: ((_ fromView: UIView, _ toView: UIView, _ style: JJAlertPresentationContext.TransitionType, _ duration: TimeInterval, _ ctx: UIViewControllerContextTransitioning) -> ())? = Default.centerTransitionAnimator
    
    /// 转场动画presentationTransitionWillBegin时,belowCoverView要展示的动画效果,默认是暗灰色view的动画效果
    ///
    /// 例如:
    ///
    ///     context.belowCorverBeginPresentAnimator = { view, coordinator in
    ///          guard let blurView = view as? UIVisualEffectView else { return }
    ///          coordinator.animate(alongsideTransition: { _ in
    ///             blurView.effect = UIBlurEffect(style: .extraLight)
    ///         }, completion: nil)
    ///     }
    ///
    public var willPresentAnimatorForBelowCoverView: ((_ belowCoverView: UIView, _ coordinator: UIViewControllerTransitionCoordinator) -> ())? = Default.dimmingBelowCoverViewAnimator(true)
    
    /// 转场动画dismissalTransitionWillBegin时,belowCoverView要展示的动画效果,默认是暗灰色view的动画效果
    ///
    /// 例如:
    ///
    ///     context.belowCorverBeginPresentAnimator = { view, coordinator in
    ///          guard let blurView = view as? UIVisualEffectView else { return }
    ///          coordinator.animate(alongsideTransition: { _ in
    ///             blurView.effect = nil
    ///         }, completion: nil)
    ///     }
    ///
    public var willDismissAnimatorForBelowCoverView: ((_ belowCoverView: UIView, _ coordinator: UIViewControllerTransitionCoordinator) -> ())? = Default.dimmingBelowCoverViewAnimator(false)
}

extension JJAlertPresentationContext {
    /// 使用一套居中弹出动画
    public func usingCenterPresentation() {
        transitionAnimator = Default.centerTransitionAnimator
        frameOfPresentedViewInContainerView = Default.centerFrameOfPresentedView
    }
    
    /// 使用一套从底部弹出动画
    public func usingBottomPresentation() {
        transitionAnimator = Default.bottomTransitionAnimator
        frameOfPresentedViewInContainerView = Default.bottomFrameOfPresentedView
    }
    
    /// 使用一套clear view的显示/隐藏动画
    public func usingClearCoverAnimators() {
        belowCoverView = Default.clearBelowCoverView
        willPresentAnimatorForBelowCoverView = Default.clearBelowCoverViewAnimator(true)
        willDismissAnimatorForBelowCoverView = Default.clearBelowCoverViewAnimator(false)
    }
    
    /// 使用一套暗灰色 view的显示/隐藏动画
    public func usingDimmingBelowCoverAnimators() {
        belowCoverView = Default.dimmingBelowCoverView
        willPresentAnimatorForBelowCoverView = Default.dimmingBelowCoverViewAnimator(true)
        willDismissAnimatorForBelowCoverView = Default.dimmingBelowCoverViewAnimator(false)
    }
    
    /// 使用一套高斯模糊的显示/隐藏动画
    public func usingBlurBelowCoverAnimators(style: UIBlurEffect.Style) {
        belowCoverView = Default.blurBelowCoverView
        willPresentAnimatorForBelowCoverView = Default.blurBelowCoverViewAnimator(style)(true)
        willDismissAnimatorForBelowCoverView = Default.blurBelowCoverViewAnimator(style)(false)
    }
}

extension JJAlertPresentationContext {
    /// 转场动画的过渡类型
    public enum TransitionType {
        case present(frames: TransitionContextFrames)
        case dismiss(frames: TransitionContextFrames)
    }
    
    /// 转场动画过程中的frame
    public struct TransitionContextFrames {
        public let fromInitialFrame: CGRect
        public let fromFinalFrame: CGRect
        public let toInitialFrame: CGRect
        public let toFinalFrame: CGRect
    }
    
    /// 点击弹出界面的其余部分事件
    public enum BelowCoverAction {
        /// 是否自动dismiss
        case autodismiss(_ auto: Bool)
        /// 自定义动作
        case customize(action: () -> ())
    }
    
    
    /// 源控制器触发生命周期
    public struct TriggerPresentingControllerLifecycle: OptionSet {
        public let rawValue: UInt
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        /// 不触发任何生命周期
        public static var none: TriggerPresentingControllerLifecycle {
            return TriggerPresentingControllerLifecycle(rawValue: 1 << 0)
        }
        
        /// 触发viewWillDisappear+viewDidDisappear
        public static var disappear: TriggerPresentingControllerLifecycle {
            return TriggerPresentingControllerLifecycle(rawValue: 1 << 1)
        }
        
        /// 触发viewWillAppear+viewDidAppear
        public static var appear: TriggerPresentingControllerLifecycle {
            return TriggerPresentingControllerLifecycle(rawValue: 1 << 2)
        }

        /// 触发所有
        public static var all: TriggerPresentingControllerLifecycle {
            let rvalue = TriggerPresentingControllerLifecycle.disappear.rawValue |
                           TriggerPresentingControllerLifecycle.appear.rawValue
            return TriggerPresentingControllerLifecycle(rawValue: rvalue)
        }
    }
}
