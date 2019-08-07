// 泛型UIPresentationController,使用方法如下:
/*
 let sv = SecondController()
 let ccc = GenericPresentationController<EmptyBackgroundPresentation, ShadowPresentationWrap, CenterAnimateTransition>(presentedViewController: sv, presenting: self)
 sv.transitioningDelegate = ccc
 present(sv, animated: true, completion: nil)
 */
/*
 let sv = SecondController()
 let ccc = GenericPresentationController<DimmingBackgroundPresentation, ShadowPresentationWrap, RightAnimateTransition>(presentedViewController: sv, presenting: self)
 sv.transitioningDelegate = ccc
 present(sv, animated: true, completion: nil)
 */
/*
 let sv = SecondController()
 let ccc = GenericPresentationController<DimmingBackgroundPresentation, OpaquePresentationWrap, BottomAnimateTransition>(presentedViewController: sv, presenting: self)
 sv.transitioningDelegate = ccc
 present(sv, animated: true, completion: nil)
 */
// 等等,你也可以自定义实现方法,只需要实现对应的协议即可
// 当然首先在第二个控制器里设置preferredContentSize, 如CGSize(width: 300, height: view.frame.height)。。。



import UIKit

/// 泛型UIPresentationController,使用时只需要提供PresentationBackgroundViewable 和 AnimatedTransitioning协议
public final class GenericPresentationController<BackgroundConfig: PresentationBackgroundViewable, WrapConfig: PresentationWrapViewable, Animating: AnimateTransitioning>: UIPresentationController, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    /// 点击空白处是否dismiss
    public var touchedDismiss: Bool = true
    override public init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
    }
    
    private var backgroundView: UIView?
    private var presentationWrappingView: UIView?
    
    override public var presentedView: UIView? {
        return presentationWrappingView
    }
    
    // MARK: - presented/dismiss 流程 -
    override public func presentationTransitionWillBegin() {
        guard let presentedViewControllerView = super.presentedView else { return }
        presentedViewControllerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let wraps = WrapConfig.makePresentationWrapeViewWithFrame(frameOfPresentedViewInContainerView) {
            self.presentationWrappingView = wraps
            presentedViewControllerView.frame = wraps.bounds
            wraps.addSubview(presentedViewControllerView)
        } else {
            presentedViewControllerView.frame = frameOfPresentedViewInContainerView
            self.presentationWrappingView = presentedViewControllerView
        }
        guard let containerView = containerView,
            let bgView = BackgroundConfig.makeBackgroundViewWithFrame(containerView.bounds)  else { return }
        if touchedDismiss {
            bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        }
        self.backgroundView = bgView
        containerView.addSubview(bgView)
        if let coordinator = presentingViewController.transitionCoordinator {
            BackgroundConfig.presentingTransformOfView(bgView, withTransitionCoordinator: coordinator)
        }
    }
    override public func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            backgroundView = nil
            presentationWrappingView = nil
        }
    }
    override public func dismissalTransitionWillBegin() {
        guard let bgView = backgroundView,
            let coordinator = presentingViewController.transitionCoordinator else { return }
        BackgroundConfig.dismissTransformOfView(bgView, withTransitionCoordinator: coordinator)
    }
    override public func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            backgroundView = nil
            presentationWrappingView = nil
        }
    }
    
    // MARK: - private method -
    @IBAction private func dismiss() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - layout -
    override public func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if let c = container as? UIViewController, c == presentedViewController {
            return c.preferredContentSize
        } else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
    override public func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        if let c = container as? UIViewController, c == presentedViewController {
            containerView?.setNeedsLayout()
        } else {
            super.preferredContentSizeDidChange(forChildContentContainer: container)
        }
    }
    override public var frameOfPresentedViewInContainerView: CGRect {
        guard let containerViewBounds = containerView?.bounds else { return .zero }
        let s = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerViewBounds.size)
        return Animating.frameOfPresentedViewWithSize(s, containerViewFrame: containerViewBounds)
    }
    override public func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        if let cv = containerView {
            backgroundView?.frame = cv.bounds
            presentationWrappingView?.frame = frameOfPresentedViewInContainerView
        }
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning -
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if let ctx = transitionContext {
            return ctx.isAnimated ? Animating.transitionDuration : 0
        }
        return 0
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        let isPresenting = presentingViewController == fromVC
        var aniView: UIView
        switch isPresenting {
        case true:
            if transitionContext.responds(to: #selector(transitionContext.view(forKey:))) {
                aniView = transitionContext.view(forKey: .to) ?? toVC.view
            } else {
                aniView = toVC.view
            }
        case false:
            if transitionContext.responds(to: #selector(transitionContext.view(forKey:))) {
                aniView = transitionContext.view(forKey: .from) ?? fromVC.view
            } else {
                aniView = fromVC.view
            }
        }
        if isPresenting {
            containerView.addSubview(aniView)
        }
        var transitionType: TransitionType
        if isPresenting {
            transitionType = TransitionType.present(final: transitionContext.finalFrame(for: toVC))
        } else {
            transitionType = TransitionType.dismiss(initial: aniView.frame)
        }
        Animating.animateOfView(aniView, transitionType: transitionType, usingTransitionContext: transitionContext)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate -
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return self
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

/*******PresentationBackgroundViewable使用方法可以参考下面提供的简单遵守协议的类型************/
//MARK: PresentationBackgroundViewable 设置custom转场动画present/dismiss过程协议
public protocol PresentationBackgroundViewable {
    /// 转场动画时,整个容器上的界面view,除presentedViewController界面之外的view
    /// 设置此view时，需要约束view的宽高,通常设置为 view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    /// 通常不设置/暗灰色view/毛玻璃效果view......
    /// - Parameter frame: 转场动画过程中转场容器containerView的bounds
    /// - Returns: 整个底部view
    static func makeBackgroundViewWithFrame(_ frame: CGRect) -> UIView?
    
    /// present动画时,BackgroundView的变化
    ///
    /// - Parameters:
    ///   - view: BackgroundView--此view为makeBackgroundViewWithFrame
    ///   - coordinator: 转场协调器
    static func presentingTransformOfView(_ view: UIView, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    
    /// dismiss动画时,BackgroundView的变化
    ///
    /// - Parameters:
    ///   - view: BackgroundView--此view为makeBackgroundViewWithFrame
    ///   - coordinator: 转场协调器
    static func dismissTransformOfView(_ view: UIView, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
}

extension PresentationBackgroundViewable {
    public static func makeBackgroundViewWithFrame(_ frame: CGRect) -> UIView? {
        return nil
    }
    public static func presentingTransformOfView(_ view: UIView, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {}
    public static func dismissTransformOfView(_ view: UIView, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {}
}
/*****************PresentationBackgroundViewable*******************/



/*******PresentationWrapViewable使用方法可以参考下面提供的简单遵守协议的类型************/
//MARK: PresentationWrapViewable 要呈现vc view的底部view
public protocol PresentationWrapViewable {
    /// 转场动画时,presentedViewController底部的view
    /// 设置此view时，需要约束view的宽高,通常设置为 view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    /// 通常不设置/有阴影view/圆角view......
    /// - Parameter frame: 转场过程中presentedViewController view的frame
    /// - Returns: presentedViewController底部的view
    static func makePresentationWrapeViewWithFrame(_ frame: CGRect) -> UIView?
}

extension PresentationWrapViewable {
    public static func makePresentationWrapeViewWithFrame(_ frame: CGRect) -> UIView? {
        return nil
    }
}
/*****************PresentationWrapViewable*******************/



/*******AnimateTransitioning使用方法可以参考下面提供的简单遵守协议的类型************/
//MARK: AnimatedTransitioning:动画过程
/// 转场动画的过渡类型
///
/// - present: present(toView的最终frame)
/// - dismiss: dismiss(fromView的初始frame)
public enum TransitionType {
    case present(final: CGRect)
    case dismiss(initial: CGRect)
}

public protocol AnimateTransitioning {
    /// 转场动画持续时间,默认为0.35s
    static var transitionDuration: TimeInterval { get }
    /// presentedViewController view的最终frame
    ///
    /// - Parameters:
    ///   - preferredContentSize: presentedViewController 界面的大小
    ///   - frame: 转场动画过程中转场容器containerView的bounds
    /// - Returns: presentedViewController view frame
    static func frameOfPresentedViewWithSize(_ preferredContentSize: CGSize, containerViewFrame frame: CGRect) -> CGRect
    /// 转场时的动画效果
    ///
    /// - Parameters:
    ///   - animateView: 要实现动画的view,根据官方文档,当custom类型的转场动画发生时,一般不去做原界面
    ///  的动画;故在这里animateView为presentedViewController view，即要呈现出来控制器view
    ///   - type: 转场动画的过渡类型
    ///   - ctx: 转场动画上下文
    static func animateOfView(_ animateView: UIView, transitionType type: TransitionType, usingTransitionContext ctx: UIViewControllerContextTransitioning)
}

extension AnimateTransitioning {
    public static var transitionDuration: TimeInterval { return 0.35 }
}
/*****************AnimatedTransitioning*******************/


/*****************以下为常用的PresentationBackgroundViewable*******************/
public struct EmptyBackgroundPresentation: PresentationBackgroundViewable {}

public struct DimmingBackgroundPresentation: PresentationBackgroundViewable {
    public static func makeBackgroundViewWithFrame(_ frame: CGRect) -> UIView? {
        let d = UIView(frame: frame)
        d.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        d.alpha = 0
        d.backgroundColor = UIColor.black
        return d
    }
    public static func presentingTransformOfView(_ view: UIView, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            view.alpha = 0.5
        }, completion: nil)
    }
    public static func dismissTransformOfView(_ view: UIView, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            view.alpha = 0
        }, completion: nil)
    }
}

public struct BlurBackgroundPresentation: PresentationBackgroundViewable {
    public static func makeBackgroundViewWithFrame(_ frame: CGRect) -> UIView? {
        let blurView = UIVisualEffectView(frame: frame)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.effect = nil
        return blurView
    }
    public static func presentingTransformOfView(_ view: UIView, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        guard let blurView = view as? UIVisualEffectView else { return }
        coordinator.animate(alongsideTransition: { _ in
            blurView.effect = UIBlurEffect(style: .extraLight)
        }, completion: nil)
    }
    public static func dismissTransformOfView(_ view: UIView, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        guard let blurView = view as? UIVisualEffectView else { return }
        coordinator.animate(alongsideTransition: { _ in
            blurView.effect = nil
        }, completion: nil)
    }
}


/*****************以下为常用的PresentationWrapViewable*******************/
public struct EmptyPresentationWrap: PresentationWrapViewable {}

public struct OpaquePresentationWrap: PresentationWrapViewable {
    public static func makePresentationWrapeViewWithFrame(_ frame: CGRect) -> UIView? {
        let p = UIView(frame: frame)
        p.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        p.isOpaque = false
        return p
    }
}

public struct ShadowPresentationWrap: PresentationWrapViewable {
    public static func makePresentationWrapeViewWithFrame(_ frame: CGRect) -> UIView? {
        let presentationWrapperView = UIView(frame: frame)
        presentationWrapperView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        presentationWrapperView.layer.shadowOpacity = 0.44
        presentationWrapperView.layer.shadowRadius = 13
        presentationWrapperView.layer.shadowOffset = CGSize(width: 0, height: -4)
        return presentationWrapperView
    }
}

/*****************以下为常用的AnimatedTransitioning*******************/
public struct BottomAnimateTransition: AnimateTransitioning {
    public static func frameOfPresentedViewWithSize(_ preferredContentSize: CGSize, containerViewFrame frame: CGRect) -> CGRect {
        let x = frame.midX - preferredContentSize.width * 0.5
        let y = frame.maxY - preferredContentSize.height
        return CGRect(origin: CGPoint(x: x, y: y), size: preferredContentSize)
    }
    public static func animateOfView(_ animateView: UIView, transitionType type: TransitionType, usingTransitionContext ctx: UIViewControllerContextTransitioning) {
        let duration = transitionDuration
        switch type {
        case .present(let f):
            animateView.frame = f.offsetBy(dx: 0, dy: f.height)
        case .dismiss(initial: let f):
            animateView.frame = f
        }
        UIView.animate(withDuration: duration, animations: {
            switch type {
            case .present(final: let f):
                animateView.frame = f
            case .dismiss(initial: let f):
                animateView.frame = f.offsetBy(dx: 0, dy: f.height)
            }
        }) { _ in
            let wasCancelled = ctx.transitionWasCancelled
            ctx.completeTransition(!wasCancelled)
        }
    }
}

public struct LeftAnimateTransition: AnimateTransitioning {
    public static func frameOfPresentedViewWithSize(_ preferredContentSize: CGSize, containerViewFrame frame: CGRect) -> CGRect {
        let x = frame.minX
        let y = frame.midY - preferredContentSize.height * 0.5
        return CGRect(origin: CGPoint(x: x, y: y), size: preferredContentSize)
    }
    public static func animateOfView(_ animateView: UIView, transitionType type: TransitionType, usingTransitionContext ctx: UIViewControllerContextTransitioning) {
        let duration = transitionDuration
        switch type {
        case .present(let f):
            animateView.frame = f.offsetBy(dx: -f.width, dy: 0)
        case .dismiss(initial: let f):
            animateView.frame = f
        }
        UIView.animate(withDuration: duration, animations: {
            switch type {
            case .present(final: let f):
                animateView.frame = f
            case .dismiss(initial: let f):
                animateView.frame = f.offsetBy(dx: -f.width, dy: 0)
            }
        }) { _ in
            let wasCancelled = ctx.transitionWasCancelled
            ctx.completeTransition(!wasCancelled)
        }
    }
}

public struct RightAnimateTransition: AnimateTransitioning {
    public static func frameOfPresentedViewWithSize(_ preferredContentSize: CGSize, containerViewFrame frame: CGRect) -> CGRect {
        let x = frame.maxX - preferredContentSize.width
        let y = frame.midY - preferredContentSize.height * 0.5
        return CGRect(origin: CGPoint(x: x, y: y), size: preferredContentSize)
    }
    public static func animateOfView(_ animateView: UIView, transitionType type: TransitionType, usingTransitionContext ctx: UIViewControllerContextTransitioning) {
        let duration = transitionDuration
        switch type {
        case .present(let f):
            animateView.frame = f.offsetBy(dx: f.width, dy: 0)
        case .dismiss(initial: let f):
            animateView.frame = f
        }
        UIView.animate(withDuration: duration, animations: {
            switch type {
            case .present(final: let f):
                animateView.frame = f
            case .dismiss(initial: let f):
                animateView.frame = f.offsetBy(dx: f.width, dy: 0)
            }
        }) { _ in
            let wasCancelled = ctx.transitionWasCancelled
            ctx.completeTransition(!wasCancelled)
        }
    }
}


public struct CenterAnimateTransition: AnimateTransitioning {
    public static func frameOfPresentedViewWithSize(_ preferredContentSize: CGSize, containerViewFrame frame: CGRect) -> CGRect {
        let x = (frame.width - preferredContentSize.width) * 0.5
        let y = (frame.height - preferredContentSize.height) * 0.5
        return CGRect(origin: CGPoint(x: x, y: y), size: preferredContentSize)
    }
    public static func animateOfView(_ animateView: UIView, transitionType type: TransitionType, usingTransitionContext ctx: UIViewControllerContextTransitioning) {
        let duration = transitionDuration
        switch type {
        case .present(let f):
            animateView.frame = f
            animateView.transform = animateView.transform.scaledBy(x: 0.2, y: 0.2)
        case .dismiss(initial: let f):
            animateView.frame = f
            animateView.transform = CGAffineTransform.identity
        }
        
        UIView.animate(withDuration: duration, animations: {
            switch type {
            case .present:
                animateView.transform = CGAffineTransform.identity
            case .dismiss:
                animateView.transform = animateView.transform.scaledBy(x: 0.2, y: 0.2)
            }
        }) { _ in
            let wasCancelled = ctx.transitionWasCancelled
            ctx.completeTransition(!wasCancelled)
        }
    }
}
