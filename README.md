# JJKit
> Layout框架/快速设定UITableView,UICollectionView,UIScrollView代理/extension等.

## 1. Layout
> 链式设置`UIView`/`CALayer`的`frame`

- 支持`UIView`以及`CAlayer`
- 通过设定`UIView`/`CALayer`的`frame`而非使用`Autolayout`
- 设定`left`/`top`/`right`/`bottom`/`centerX`/`centerY`/`height`/`width`/`center`/`size`/`edges`

```swift
let v = UITableView()
v.jj.layout { make in
    make.width.equalTo(view).offsetBy(-50)
    make.center.equalTo(view)           
    make.height.equalTo(view).offsetBy(-150)
}
```
## 2. ScrollDataDelegate
> 方便快捷的链式设置`UIScrollViewDelegate`/`UITableViewDelegate`/`UITableViewDataSource`/`UITableViewDataSourcePrefetching`/`UICollectionViewDelegate`/`UICollectionViewDataSource`/`UICollectionViewDataSourcePrefetching`/`UICollectionViewDelegateFlowLayout`
```swift
let v = UITableView()
v.jj.bind { make in
    make.didScroll({ sc in
        print(sc.contentOffset.y)
    })
    make.cellForRow({ tb, ip  in
        let cell = tb.dequeueReusableCell()
        cell.textLabel?.text = "\(ip.section)---\(ip.row)"
        return cell
    }).numberOfRows({ _, _ in
        return 100
    }).heightForRow({ _, ip in
        return ip.row < 50 ? 44 : 64
    })
}
```
## 3. GCDTimer
> 使用`DispatchSourceTimer`代替`NSTimer`的组件
```swift
let timer = GCDTimer(repeating: 5.0) { _ in
    print("123")
}
```
## 4. JJCycleView
> 简单的轮播图组件,此组件并不强制使用`SDwebImage`或者`Kingfihser`。只需要实现`CycleViewImageSource`协议即可将对应的内容显示在`UIImageView`上
- 比如使用`Kingfihser`
```swift
extension String: CycleViewImageSource {
    public func showInView(_ view: UIImageView) {
        let u = URL(string: url)
        yy_setImage(with: u, placeholder: nil, options: [.progressiveBlur, .setImageWithFadeAnimation], completion: nil)
    }
}
```
## 5. AttributMaker
> 方便快捷的将`String`转换成`NSAttributedString`
```swift
let str = "JJkit之AttributMaker"
let l = UILabel()
l.attributedText = str.jj.attributeMake({ make in
    make.for("JJkit")?.foregroundColor(.red).font(UIFont.boldSystemFont(ofSize: 23))
    make.for(6..<10)?.foregroundColor(.orange).link(URL(string: "www.baidu.com")!)
    make.for(5)?.strikethroughStyle(.single)
})
```
## 6. MaterialIcons
> 方便的将google icons转换成`UIImage`/`NSAttributedString`.
- 图标列表 https://material.io/tools/icons/?style=baseline
```swift
let l = UILabel() 
l.attributedText = MaterialIcons.settings.attributeStringWith(size: 20, transform: { make in
    make.tintColor(.red)
    make.backgroundColor(.blue)
})

let b = UIButton()
let norImg = MaterialIcons.radio_button_unchecked.imageWith(size: CGSize(width: 30, height: 30)) { make in
    make.tintColor(.red)
}
let disImg = MaterialIcons.radio_button_unchecked.imageWith(size: CGSize(width: 30, height: 30)) { make in
    make.tintColor(.gray)
}
b.setImage(norImg, for: .normal)
b.setImage(disImg, for: .disabled)
```
## 7. 缓动函数---[动画效果](https://easings.net/)
> 增加CAKeyframeAnimation动画曲线,目前可以设置`CGFloat`/`CGPoint`/`CGSize`方面的动画
```swift
let l = CALayer()
l.backgroundColor = UIColor.purple.cgColor
l.jj.layout { make in
    make.width.height.equalTo(30)
    make.top.equalTo(80)
}
l.cornerRadius = 15
view.layer.addSublayer(l)
let animator = CAKeyframeAnimation(keyPath: "position")
animator.duration = 1
let start = CGPoint(x: 15, y: 95)
let final = CGPoint(x: view.jj.width - 15, y: view.jj.height - 15)
animator.setValues(from: start, to: final, using: .BounceEaseOut)
l.position = final
l.add(animator, forKey: "lkeyframe")
```
## 8. AlertPresentationController
> - 方便快捷的自定义`UIPresentationController`弹窗控制器,可以通过`AlertPresentationContext`设置各种动画效果。
> - 其中`GenericPresentationContext.Default`提供了几种默认设置

- 使用默认设置
```swift
let nextVc = ThirdViewController()
let g = AlertPresentationController(show: nextVc, from: self) // 这里使用默认的设置,在屏幕中央且使用暗灰色背景弹出下一控制器
nextVc.transitioningDelegate = g
present(nextVc, animated: true, completion: nil)
```
- 其他设置
```swift
let nextVc = ThirdViewController()
let g = AlertPresentationController(show: nextVc, from: self) { ctx in
    // 触摸弹出界面之外的地方,弹出界面不消失
    ctx.touchedCorverDismiss = false 
    // 设置弹出界面要显示的位置---frame
    ctx.frameOfPresentedViewInContainerView = AlertPresentationContext.Default.bottomFrameOfPresentedView
    // 设置弹出界面的底部封面部分为高斯模糊界面
    ctx.belowCoverView = AlertPresentationContext.Default.blurBelowCoverView
    // 设置弹出界面的底部封面部分的显示动画效果
    ctx.willPresentAnimatorForBelowCoverView = AlertPresentationContext.Default.blurBelowCoverViewAnimator(true)
    // 设置弹出界面的底部封面部分的消失动画效果
    ctx.willDismissAnimatorForBelowCoverView = AlertPresentationContext.Default.blurBelowCoverViewAnimator(false)
    // 设置弹出界面的动画效果为从底部弹出
    ctx.transitionAnimator = AlertPresentationContext.Default.bottomTransitionAnimator
}
nextVc.transitioningDelegate = g
present(nextVc, animated: true, completion: nil)
```
- 你可以提供`AlertPresentationContext`的属性来实现自定义效果

## 9. 其它extension及组件

### 9.1 `UIImage`扩展
- 1.使用`CGContext`画布block,来初始化UIImage,可以方便的在block内做各种操作,而不用去写大量重复操作
```swift
imgview.image = UIImage(size: imgview.jj.size, action: { ctx in
    self.view.layer.render(in: ctx) 
})
```
- 2.线性颜色渐变图像
```swift
imgview.image = UIImage(linearColors: { size -> ([(UIColor, CGFloat)]) in
    let color1 = (UIColor.red, CGFloat(0.5))
    let color2 = (UIColor.orange, CGFloat(0.5))
    return [color1, color2]
}, size: imgview.jj.size)
```

### 9.2 `Codable`扩展-----[具体用法](https://github.com/zgjff/Blog/issues/1)

### 9.3 `UIButton`扩展
```swift
let b = UIButton() 
// 方便的为UIButton的各种状态设置背景色
b.jj.setBackgroundColor(.red, for: .normal) 
b.jj.setBackgroundColor(.gray, for: .disabled)
```
### 9.4 其它内容
