JJRouter
==================

适用于Swift的简单好用、支持block回调、转发、拦截功能的路由框架


思路
=================
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

使用方法
=================
## 一、注册
### 1.1 实现路由源协议`JJRouterSource`
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
### 1.2 调用`register`方法
```swift
SimpleRouter.allCases.forEach { try! $0.register() }
```

## 二、跳转
### 2.1 通过具体的`JJRouterSource`对象跳转路由
```swift
(try? JJRouter.default.open(SimpleRouter.systemPush))?.jump(from: self)
```
### 2.2 通过具体的`path`跳转路由
```swift
(try? JJRouter.default.open("/app/systemPush"))?.jump(from: self)
```
### 2.3 通过具体的`URL`跳转路由
```swift
if let url = URL(string: "https://www.appwebsite.com/app/systemPush/") {
    (try? JJRouter.default.open(url))?.jump(from: self)
}
```

## 三、传参数
### 3.1 通过实现`JJRouterSource`协议的具体对象传参数
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
### 3.2 通过`path`或者`URL`传参数
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

### 3.3 通过`path`或者`URL`带`query`传参数
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

### 3.4 通过`context`传参数
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

### 3.5 混和`URL`与`context`传参数
```swift
// 注册
enum PassParameterRouter {
    case mixUrlAndContext = "/app/mixUrlAndContext/:pid/:text"
    ...
}
// A
(try? JJRouter.default.open("/app/mixUrlAndContext/12/keke", context: arc4random_uniform(2) == 0))?.jump(from: self)
```

### 3.6 将参数用于`UIViewController`的初始化
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


## 四、回调
### 4.1 正常block回调: A跳转B, B通过路由block将数据回调给A
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

### 4.2 非正常block回调: A跳转B, A通过路由block将实时数据回调给B
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

### 4.3 转发block回调: A需要跳转B,但是条件达不到,需要跳转到其它路由界面C,此时可以正常拿到C的回调
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

## 五、匹配到路由控制器与当前控制器属于同一类时情景

### 5.1 3种操作
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

### 5.2 匹配到相同类的协议方法事例
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