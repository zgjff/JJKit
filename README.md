# JJKit
> 包括便捷扩展、路由、轮播图、转场动画的框架
---------
[![MIT](https://img.shields.io/github/license/zgjff/JJKit)](https://www.apache.org/licenses/LICENSE-2.0.html)
[![swift-5.5](https://img.shields.io/badge/swift-5.5-blue)](https://www.swift.org)
![iOS-11.0](https://img.shields.io/badge/iOS-11.0-red)
[![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/zgjff/JJKit)](https://github.com/zgjff/JJKit)
[![Cocoapods](https://img.shields.io/cocoapods/v/JJKit)](https://cocoapods.org/pods/JJKit)


# 功能列表
=================
|功能|名称|
|:----:|:----:|
|路由|[JJRouter](#一-路由-jjrouter)|
|Toast|[JJToast](#二-toast-jjtoast)|
|轮播图|[JJCarouselView](./Documentation/JJCarouselView.md)|
|转场动画|[JJTransition](#三-弹窗转场动画-jjtransition)|
|API扩展|[Extensions](./Documentation/Extensions.md)|

# 一: 路由: JJRouter

简单好用、支持block回调、转发、拦截功能的路由框架


## 思路
最基本思路: 自己负责自己的显示方式
> 即从A跳转到B,由B自己来决定是push还是present，亦或者使用自定义的转场动画来显示

所以路由界面需要遵守`JJRouterDestination`协议并实现`func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController)`方法

eg:
```swift
extension SystemPushController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        // push
        sourceController.navigationController?.pushViewController(self, animated: true)
        // present
        sourceController.present(self, animated: true)
        // 自定义转场动画--提供使present/dismiss动画跟系统push/pop动画一致的转场动画
        let navi = UINavigationController(rootViewController: self)
        navi.modalPresentationStyle = .fullScreen
        navi.transitioningDelegate = pushPopStylePresentDelegate
        sourceController.present(navi, animated: true)
        // 自定义转场动画---居中弹窗
        let pd = AlertPresentationController(show: self, from: sourceController) { ctx in
            ctx.usingBlurBelowCoverAnimators(style: .regular)
        }
        transitioningDelegate = pd
        sourceController.present(self, animated: true) {
            let _ = pd
        }
    }
}
```

## 使用方法
## 1.1、注册
### 1.1.1 实现路由源协议`JJRouterSource`
```swift
enum SimpleRouter: String, CaseIterable {
    case systemPush = "/app/systemPush"
    ...
}

extension SimpleRouter: JJRouterSource {
    var routerPattern: String {
        return rawValue
    }

    func makeRouterDestination(parameters: [String : String], context: Any?) -> JJRouterDestination {
        switch self {
        case .systemPush:
            return SystemPushController()
        ...
        }
    }
}

```
### 1.1.2 调用`register`方法
```swift
SimpleRouter.allCases.forEach { try! $0.register() }
```

## 1.2、跳转
### 1.2.1 通过具体的`JJRouterSource`对象跳转路由
```swift
(try? JJRouter.default.open(SimpleRouter.systemPush))?.jump(from: self)
```
### 1.2.2 通过具体的`path`跳转路由
```swift
(try? JJRouter.default.open("/app/systemPush"))?.jump(from: self)
```
### 1.2.3 通过具体的`URL`跳转路由
```swift
if let url = URL(string: "https://www.appwebsite.com/app/systemPush/") {
    (try? JJRouter.default.open(url))?.jump(from: self)
}
```

## 1.3、传参数
### 1.3.1 通过实现`JJRouterSource`协议的具体对象传参数
```swift
// 注册
enum PassParameterRouter {
    case byEnum(p: String, q: Int)
    ...
}
var routerParameters: [String : String] {
    switch self {
        case let .byEnum(p: p, q: q):
        return ["p": p, "q": "\(q)"]
        ...
    }
}
// A
(try? JJRouter.default.open(PassParameterRouter.byContext, context: 12))?.jump(from: self)
// 参数: ["p": "entry", "q": 12]
```
### 1.3.2 通过`path`或者`URL`传参数
```swift
// 注册
enum PassParameterRouter {
    case byUrl = "/app/passParameterByUrl/:pid/:name"
    ...
}
// A
(try? JJRouter.default.open("/app/passParameterByUrl/12/jack"))?.jump(from: self)
// 参数: ["pid": "12", "name": "jack"]
```

### 1.3.3 通过`path`或者`URL`带`query`传参数
```swift
// 注册
enum PassParameterRouter {
    case byUrlWithQuery = "/app/search"
    ...
}
// A
(try? JJRouter.default.open("/app/search?name=lili&age=18"))?.jump(from: self)
// 参数: ["name": "lili", "age": "18"]
```

### 1.3.4 通过`context`传参数
```swift
// 注册
enum PassParameterRouter {
    case byContext = "/app/passParameterByContext"
    ...
}
// A
(try? JJRouter.default.open(PassParameterRouter.byContext, context: 12))?.jump(from: self)(self)
// B
func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
    if let pid = result.context as? Int {
        self.pid = pid
    }
    sourceController.navigationController?.pushViewController(self, animated: true)
    }
```

### 1.3.5 混和`URL`与`context`传参数
```swift
// 注册
enum PassParameterRouter {
    case mixUrlAndContext = "/app/mixUrlAndContext/:pid/:text"
    ...
}
// A
(try? JJRouter.default.open("/app/mixUrlAndContext/12/keke", context: arc4random_uniform(2) == 0))?.jump(from: self)
```

### 1.3.6 将参数用于`UIViewController`的初始化
```swift
// 注册
enum PassParameterRouter {
    case parameterForInit = "/app/parameterForInit/:id"
    ...
}
func makeRouterDestination(parameters: [String : String], context: Any?) -> JJRouterDestination {
    switch self {
        case .parameterForInit:
            let idstr = parameters["id"] ?? ""
            let numberFormatter = NumberFormatter()
            let id = numberFormatter.number(from: idstr)?.intValue
            return PassParametersForInitController(id: id ?? 0)
        ...
    }
}
// A
(try? JJRouter.default.open("/app/parameterForInit/66"))?.jump(from: self)
// B
init(id: Int) {
    pid = id
    super.init(nibName: nil, bundle: nil)
}
```


## 1.4、回调
### 1.4.1 正常block回调: A跳转B, B通过路由block将数据回调给A
```swift
// A
// 不缩写的代码逻辑应该是这样的
let result = try? JJRouter.default.open(BlockRouter.backBlock)
let router = result?.jump(from: self)
// 当然也可以缩写
// let router = (try? JJRouter.default.open(BlockRouter.backBlock))?.jump(from: self)
router?.register(blockName: "onSend", callback: { obj in
    print("get data: \(obj) from router block")
})
// B
dismiss(animated: true) { [weak self] in
    self?.router?.perform(blockName: "onSend", withObject: 5)
}
```

### 1.4.2 非正常block回调: A跳转B, A通过路由block将实时数据回调给B
> 主要用于,A的数据是实时变化的,B需要拿到A的最新数据

```swift
// A
let router = (try? JJRouter.default.open(BlockRouter.frontBlockB))?.jump(from: self)
router?.register(blockName: "onNeedGetNewestData", callback: { [weak self] obj in
    guard let self = self,
        let block = obj as? (Int) -> () else {
            return
        }
    block(self.data)
})
// B
let block: (Int) -> () = { [weak self] data in
    self?.button.setTitle("\(data)", for: [])
}
router?.perform(blockName: "onNeedGetNewestData", withObject: block)
```

### 1.4.3 转发block回调: A需要跳转B,但是条件达不到,需要跳转到其它路由界面C,此时可以正常拿到C的回调
> 这里A虽然是调用B的路由,但是仍然可以收到C的回调
```swift
// register 转发
func register() throws {
    try JJRouter.default.register(pattern: routerPattern, mapRouter: { matchResult in
        guard case .mapBlock = self else {
            return self
        }
        let needGotoLoginController = arc4random_uniform(2) == 0
        if needGotoLoginController { // 需要登录,转发给登录路由
            return SimpleRouter.login
        }
        return self
    })
}
// A
let router = (try? JJRouter.default.open(BlockRouter.mapBlock))?.jump(from: self)
router?.register(blockName: "loginSuccess", callback: { _ in
    print("登录成功")
})
```

## 1.5、匹配到路由控制器与当前控制器属于同一类时情景

### 1.5.1 3种操作
```swift
/// 匹配到的路由跟当前展示的界面相同时的操作
public enum MatchedSameRouterDestinationAction {
    /// 不做任何操作
    case none
    /// 更新数据
    case update
    /// 展示新界面
    case new
}
```

### 1.5.2 匹配到相同类的协议方法事例
```swift
/// 当匹配到的路由跟当前展示的界面相同时的操作方法,默认返回`new`
///
/// 返回`none`时,不做任何操作
///
/// 返回`update`时,会调用`updateWhenRouterIdentifierIsSame`方法来更新当前界面
///
/// 返回`new`时,会调用`showDetail`来重新展示新的界面
/// - Parameter result: 匹配结果
func actionWhenMatchedRouterDestinationSameToCurrent(withNewMatchRouterResult result: JJRouter.MatchResult) -> JJRouter.MatchedSameRouterDestinationAction {
    return .update
}

func updateWhenRouterIdentifierIsSame(withNewMatchRouterResult result: JJRouter.MatchResult) {
    pid = parseId(from: result.parameters)
    title = "\(pid)"
}
```

# 二: Toast: JJToast

泛型、可扩展、样式丰富多样、支持自定义显示样式


## 思路
> `toast`分拆为样式加显示容器; 样式、显示容器高度抽象化,框架只在底层做相关的逻辑; 具体实现交由上层处理

## 2.1: 抽象化相关协议
### 2.1.2 `toast`样式组件协议
#### 2.1.2.1: 最基本的`toast`样式组件协议
> 此协议统筹约束所有的样式组件内容,并且跟样式容器协议交互(容器也只跟此层交互): 此协议约定了一共5项内容, 具体如下:

```swift
/// `toast`样式组件协议
public protocol JJToastItemable: AnyObject {
    associatedtype Options: JJToastItemOptions
    /// toast样式组件代理
    var delegate: JJToastableDelegate? { get set }
    /// 配置
    var options: Options { get }
    /// 唯一标识符
    var identifier: String { get }
    /// 使用对应的`toast`样式配置以及要显示`toast`的view的size大小, 计算并布局`toast`样式
    /// - Parameters:
    ///   - options: 配置
    ///   - size: 要显示`toast`的view的size大小
    func layoutToastView(with options: Options, inViewSize size: CGSize)
    /// 根据显示`toast`的view的size大小重置`toast`样式size
    /// - Parameter size: 显示`toast`的view的size
    func resetContentSizeWithViewSize(_ size: CGSize)
}
```

#### 2.1.2.2: 3种常用的`toast`类型: 框架在`JJToastItemable`协议之上也抽离出了常用的3种`toast`类型, 此3种常用类型只是约束开发相应类型的大致方向

* 文字: `JJTextToastItemable`
```swift
public protocol JJTextToastItemable: JJToastItemable {
    /// 展示文字内容
    /// - Parameters:
    ///   - text: 内容
    ///   - labelToShow: label
    func display(text: NSAttributedString, in labelToShow: UILabel)
}
```
* 指示器: `JJIndicatorToastItemable`
```swift
  /// 显示指示器的 `toast`样式组件协议
public protocol JJIndicatorToastItemable: JJToastItemable {
    /// 开始动画
    func startAnimating()
}
```
* 进度条: `JJProgressToastItemable`
```swift
/// 显示进度条的 `toast`样式组件协议
public protocol JJProgressToastItemable: JJToastItemable {
    /// 设置进度条进度
    /// - Parameters:
    ///   - progress: 进度
    ///   - flag: 是否开启动画
    func setProgress(_ progress: Float, animated flag: Bool)
}
```
#### 2.1.2.3: 混合两项`toast`的组合样式: 
框架提供了一种独特的`toast`样式具体实现: `JJMixTwoToastItem`, 它可以很方便的提供混合组合, 文字+文字、文字+指示器、文字+进度条、文字+图像、指示器+进度条、指示器+指示器。。。。

它是一个泛型类: 
```swift
JJMixTwoToastItem<First: JJToastItemable, Second: JJToastItemable>
```
所以你可以随意的组合任意两种样式
eg
```swift
1: 文字+文字
JJMixTwoToastItem(first: JJTextToastItem(attributedString: NSAttributedString(string: "标题", attributes: [.font: UIFont.systemFont(ofSize: 22), .foregroundColor: UIColor.jRandom()])), second: JJTextToastItem(text: "我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容"))

2: 指示器+文字
JJMixTwoToastItem(first: JJActivityToastItem(), second: JJTextToastItem(text: "我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容"))

3: 指示器+变换的文字
JJMixTwoToastItem(first: JJActivityToastItem(), second: JJVaryTextToastItem(texts: ["加载中", "加载中.", "加载中..", "加载中..."]))

4: 指示器+指示器
JJMixTwoToastItem(first: JJArcrotationToastItem(), second: JJActivityToastItem())

5: 文字+图像
JJMixTwoToastItem(first: JJTextToastItem(text: "进击的象🐘"), second: JJImageToastItem(url: url, display: { url, imageView in
    imageView.sd_setImage(with: url, completed: nil)
}))

....
```

### 2.1.3 `toast`容器组件协议
> 此协议统筹约束所有的容器逻辑: 此协议约定了一共10项内容, 具体如下:
```swift
/// `toast`容器协议
public protocol JJToastContainer: UIView, JJToastableDelegate, CAAnimationDelegate {
    /// 配置
    var options: JJToastContainerOptions { get set }
    /// 状态
    var state: JJToastState { get set }
    /// 具体承载的`toast`样式
    var toastItem: (any JJToastItemable)? { get }
    /// 显示toast
    func present(_ viewToShow: UIView, animated flag: Bool)
    /// 隐藏toast
    func dismiss(animated flag: Bool)
    /// 在一定时间之后执行自动隐藏
    func performAutoDismiss(after delay: TimeInterval)
    /// 取消自动隐藏
    func cancelperformAutoDismiss()
    /// 观察屏幕方向改变
    func addOrientationDidChangeObserver(action: @escaping (CGSize) -> ()) -> NSObjectProtocol?
    /// 取消屏幕方向观察
    func removeOrientationDidChangeObserver(_ observer: NSObjectProtocol?)
    /// 移除
    func remove()
}
```
## 使用方法
### 3.1 基本使用
```swift
let color = UIColor.jRandom()
let texts = (1..<11).reversed().map { NSAttributedString(string: "\($0)", attributes: [.font: UIFont.systemFont(ofSize: 37), .foregroundColor: color]) }
view.jj.makeToast(JJVaryTextToastItem(attributedStrings: texts))
    .updateItem(options: { options in
        options.loopCount = 1
    })
    .duration(.distantFuture)
    .autoDismissOnTap()
    .show(animated: true)
```
#### 3.1.2 生成
使用`makeToast`可以生成链式操作对象: `JJToastDSL<T> where T: JJToastItemable`
```swift
/// 根据对应的`toast`样式生成相应的链式操作
    /// - Parameter item: `toast`
    /// - Returns: `toast`链式操作
func makeToast<T>(_ item: T) -> JJToastDSL<T> where T: JJToastItemable {
    JJToastDSL(view: base, item: item)
}
```
#### 3.1.3 配置`toast`样式
因为`JJToastDSL`是泛型,所以可以调用`updateItem`方法,配置对应`toast`样式的配置
```swift
/// 修改`JJToastItemable`的配置
/// - Parameter block: block配置
func updateItem(options block: (_ options: inout T.Options) -> ()) -> Self {
    block(&itemOptions)
    return self
}
```
#### 3.1.4 配置容器样式，显示时间、显示隐藏动画: 具体方法如下
```swift
/// 使用渐变色容器
.useContainer(JJGradientContainer(colors: [.jRandom(), .jRandom(), .jRandom()]))
/// 显示动画
.appearAnimations([.scaleX(0.2), .opacity(0.3)])
/// 隐藏动画
.disappearAnimations([.scaleY(0.2).opposite, .opacity(0.3).opposite])
/// 点击自动消失
.autoDismissOnTap()
/// 时间:只要不主动隐藏就会永久显示
.duration(.distantFuture)
```
### 3.2: 具体使用
#### 3.2.1: 显示文字
```swift
view.jj.show(message: text)
```
#### 3.2.1: 显示系统指示器: 
```swift
view.jj.showActivityIndicator()
```
#### 3.2.2: 指定位置显示网络图片
```swift
@IBAction func showWebImage() {
    guard let url = URL(string: "http://apng.onevcat.com/assets/elephant.png") else {
        return
    }
    view.jj.makeToast(JJImageToastItem(url: url, display: { url, imageView in
        imageView.sd_setImage(with: url, completed: nil)
    })).updateItem(options: { opt in
        opt.imageSize = .fixed(CGSize(width: 150, height: 150))
        opt.configUIImageView = { iv in
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
        }
    })
    .autoDismissOnTap()
    .duration(.distantFuture)
    .position(.center)
    .show()
}
```
#### 3.2.3: 使用纯色容器
```swift
@IBAction func showUsingColorContainerTextToast() {
    view.jj.makeToast(JJTextToastItem(text: "我是一个带色彩背景的toast"))
        .useContainer(JJColorfulContainer(color: .jRandom()))
        .duration(.distantFuture)
        .autoDismissOnTap()
        .show()
}
```
#### 3.2.4: 混合显示文字+指示器:
```swift
@IBAction func showMixActivityAndTextToast() {
      view.jj.makeToast(JJMixTwoToastItem(first: JJActivityToastItem(), second: JJTextToastItem(text: "我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容")))
          .duration(.distantFuture)
          .autoDismissOnTap()
          .show()
  }
```

## 4: 自定义: 
你可以自定义任何你所需的样式, 然后`makeToast`使用对应的对象,后续的配置+显示+隐藏逻辑,框架都以配置好。


# 三: 弹窗转场动画: JJTransition
## 3.1: 弹窗驱动器`JJAlertPresentationController`
> `present`类型`modalPresentationStyle`为`custom`,继承自`UIPresentationController`

### 3.1.1 简单使用事例
以高斯模糊为蒙层,且居中弹出效果
```swift
let pd = JJAlertPresentationController(show: self, from: sourceController) { ctx in
    ctx.usingBlurBelowCoverAnimators(style: .dark)
}
A.present(B, animated: true) {
    let _ = pd
}
```

### 3.1.2 弹窗效果设置---必须在上下文`JJAlertPresentationContext`中设置

#### 3.1.2.1 转场动画持续时间,默认0.2s
```swift
public var duration: TimeInterval = 0.2
```
#### 3.1.2.2 弹出界面的其余部分点击事件,默认为自动`dismiss`
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

#### 3.1.2.3 转场动画中,弹出页面的`frame`,默认使弹出页面居中显示
```swift
public var frameOfPresentedViewInContainerView: ((_ containerViewBounds: CGRect, _ preferredContentSize: CGSize) -> (CGRect))? = Default.centerFrameOfPresentedView
```

#### 3.1.2.4 转场动画中,弹出页面的修饰包装view,默认4个圆角带阴影view
```swift
public var presentationWrappingView: ((_ presentedViewControllerView: UIView, _ frameOfPresentedView: CGRect) -> UIView)? = Default.shadowAllRoundedCornerWrappingView(10)
```

#### 3.1.2.5 转场动画中,`containerView`的效果,默认是暗灰色view
```swift
public var belowCoverView: ((_ frame: CGRect) -> UIView)? = Default.dimmingBelowCoverView
```

#### 3.1.2.6 转场动画的具体实现,默认是弹出居中view的动画效果
```swift
public var transitionAnimator: ((_ fromView: UIView, _ toView: UIView, _ style: JJAlertPresentationContext.TransitionType, _ duration: TimeInterval, _ ctx: UIViewControllerContextTransitioning) -> ())? = Default.centerTransitionAnimator
```

#### 3.1.2.7 转场动画中,`containerView`的展示动画效果,默认是暗灰色view的动画效果
```swift
public var willPresentAnimatorForBelowCoverView: ((_ belowCoverView: UIView, _ coordinator: UIViewControllerTransitionCoordinator) -> ())? = Default.dimmingBelowCoverViewAnimator(true)
```

#### 3.1.2.8 转场动画中,`containerView`的消失动画效果,默认是暗灰色view的动画效果
```swift
public var willDismissAnimatorForBelowCoverView: ((_ belowCoverView: UIView, _ coordinator: UIViewControllerTransitionCoordinator) -> ())? = Default.dimmingBelowCoverViewAnimator(false)
```

## 3.2: 提供使present/dismiss动画跟系统push/pop动画一致的转场动画协议`JJPushPopStylePresentDelegate`

### 3.2.1使用方法
A->B, B准守`JJPushPopStylePresentDelegate`协议,然后在在跳转的时候设置B的`transitioningDelegate`为自身
```swift
let b = UIViewController()
let navi = UINavigationController(rootViewController: b)
navi.modalPresentationStyle = .fullScreen
navi.transitioningDelegate = b.pushPopStylePresentDelegate
a.present(navi, animated: true)
```


使用需求
=================
* iOS 11.0+
* Swift 5.5+

安装
=================

Cocoapods
```
use_frameworks!
pod 'JJKit'
```
