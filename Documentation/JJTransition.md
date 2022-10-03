JJTransition
==================
便捷方便的转场动画助手

## 一: 弹窗驱动器`JJAlertPresentationController`
> `present`类型`modalPresentationStyle`为`custom`,继承自`UIPresentationController`

### 1.1 简单使用事例
以高斯模糊为蒙层,且居中弹出效果
```swift
let pd = JJAlertPresentationController(show: self, from: sourceController) { ctx in
    ctx.usingBlurBelowCoverAnimators(style: .dark)
}
A.present(B, animated: true) {
    let _ = pd
}
```

### 1.2 弹窗效果设置---必须在上下文`JJAlertPresentationContext`中设置

#### 1.2.1 转场动画持续时间,默认0.2s
```swift
public var duration: TimeInterval = 0.2
```
#### 1.2.2 弹出界面的其余部分点击事件,默认为自动`dismiss`
```swift
public var belowCoverAction = JJAlertPresentationContext.BelowCoverAction.autodismiss(true)
行为action为枚举值
public enum BelowCoverAction {
    /// 是否自动dismiss
    case autodismiss(_ auto: Bool)
    /// 自定义动作
    case customize(action: () -> ())
}
```
> 可以在弹窗出现之后通过`AlertPresentationController`的`updateContext`方法随时更改此属性
> eg:可以在弹窗展示的时候为`.autodismiss(false)`,然后,在页面事件处理完成之后改为`.autodismiss(true)`
> 同时,默认的点击空白消失是带动画的.如果不想带动画,请设置为`.customize`,在block内部手动调用dismiss

#### 1.2.3 转场动画中,弹出页面的`frame`,默认使弹出页面居中显示
```swift
public var frameOfPresentedViewInContainerView: ((_ containerViewBounds: CGRect, _ preferredContentSize: CGSize) -> (CGRect))? = Default.centerFrameOfPresentedView
```

#### 1.2.4 转场动画中,弹出页面的修饰包装view,默认4个圆角带阴影view
```swift
public var presentationWrappingView: ((_ presentedViewControllerView: UIView, _ frameOfPresentedView: CGRect) -> UIView)? = Default.shadowAllRoundedCornerWrappingView(10)
```

#### 1.2.5 转场动画中,`containerView`的效果,默认是暗灰色view
```swift
public var belowCoverView: ((_ frame: CGRect) -> UIView)? = Default.dimmingBelowCoverView
```

#### 1.2.6 转场动画的具体实现,默认是弹出居中view的动画效果
```swift
public var transitionAnimator: ((_ fromView: UIView, _ toView: UIView, _ style: JJAlertPresentationContext.TransitionType, _ duration: TimeInterval, _ ctx: UIViewControllerContextTransitioning) -> ())? = Default.centerTransitionAnimator
```

#### 1.2.7 转场动画中,`containerView`的展示动画效果,默认是暗灰色view的动画效果
```swift
public var willPresentAnimatorForBelowCoverView: ((_ belowCoverView: UIView, _ coordinator: UIViewControllerTransitionCoordinator) -> ())? = Default.dimmingBelowCoverViewAnimator(true)
```

#### 1.2.8 转场动画中,`containerView`的消失动画效果,默认是暗灰色view的动画效果
```swift
public var willDismissAnimatorForBelowCoverView: ((_ belowCoverView: UIView, _ coordinator: UIViewControllerTransitionCoordinator) -> ())? = Default.dimmingBelowCoverViewAnimator(false)
```

## 二: 提供使present/dismiss动画跟系统push/pop动画一致的转场动画协议`JJPushPopStylePresentDelegate`

### 2.1使用方法
A->B, B准守`JJPushPopStylePresentDelegate`协议,然后在在跳转的时候设置B的`transitioningDelegate`为自身
```swift
let b = UIViewController()
let navi = UINavigationController(rootViewController: b)
navi.modalPresentationStyle = .fullScreen
navi.transitioningDelegate = b.pushPopStylePresentDelegate
a.present(navi, animated: true)
```