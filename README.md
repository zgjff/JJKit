# JJKit
> Layout框架/快速设定UITableView,UICollectionView,UIScrollView代理/extension等.

## 1. Layout
> 链式设置UIView/CALayer的frame

- 支持UIView以及CAlayer
- 通过设定UIView/CALayer的frame而非使用Autolayout
- 设定left/top/right/bottom/centerX/centerY/height/width/center/size/edges

```swift
let v = UITableView()
v.jj.layout { make in
    make.width.equalTo(view).offsetBy(-50)
    make.center.equalTo(view)           
    make.height.equalTo(view).offsetBy(-150)
}
```
## 2. ScrollDataDelegate
> 方便快捷的设置`UIScrollViewDelegate`/`UITableViewDelegate`/`UITableViewDataSource`/`UITableViewDataSourcePrefetching`/`UICollectionViewDelegate`/`UICollectionViewDataSource`/`UICollectionViewDataSourcePrefetching`/`UICollectionViewDelegateFlowLayout`
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
    })
    make.numberOfRows({ _, _ -> Int in
        return 100
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
## 5. 各种其他extension....
