///
/// example1:正确使用
///
///     v.jj.bind { make in
///         make.didScroll(self.didssss(_:))
///         make.cellForRow({ tb, ip -> UITableViewCell in
///             let cell = tb.dequeueReusableCell()
///             cell.textLabel?.text = "\(ip.section)---\(ip.row)"
///             return cell
///         })
///         make.numberOfRows({ _, _ -> Int in
///             return 100
///         })
///     }
///
///  example2:循环使用1:build对应代理函数的时候直接使用当前的函数
///
///     v.jj.bind { make in
///         make.didScroll(didScroll) // 这里直接调用didScroll函数,会造成循环引用
///     }
///     private func didScroll(_ tab: UIScrollView) {
///         print("didScroll-----")
///     }
///
///  example3:正确使用
///
///     v.jj.bind {make in
///         make.cellForRow({ [unowned self] tb, ip  in
///         return self.makeCell(for: tb, ip: ip) // 这里使用了[unowned self],虽然也调用了本地的函数,却不会造成循环引用
///     })
///     make.numberOfRows({ _, _ -> Int in
///         return 100
///     })
///     }
///     private func makeCell(for tab: UITableView, ip: IndexPath) -> UITableViewCell {
///         let cell = tab.dequeueReusableCell()
///         cell.textLabel?.text = "\(ip.section)---\(ip.row)"
///     return cell
///     }
///
/// example4: 正确使用
///
/// v.jj.bind {make in
///     make.cellForRow({ tb, ip  in
///         let cell = tb.dequeueReusableCell()
///         cell.textLabel?.text = "\(ip.section)---\(ip.row)"
///         return cell
///     })
///     make.numberOfSections(viewModel.numberOfSections) // 这里虽然直接使用了ViewModel中的numberOfSections函数,却不会造成循环引用
///     make.numberOfRows({ _, _ -> Int in
///         return 100
///     })
/// }
///  ViewModel.swift
/// final class ViewModel {
///     func numberOfSections(in tab: UITableView) -> Int {
///         return 2
///     }
/// }
import UIKit

private var JJ_ScrollView_Builder = 0

extension JJ where Object: UITableView {
    /// 无需设置UITableView的代理,而直接通过闭包设置UITableView的delegate/dataSource/prefetchDataSource
    ///
    /// - Parameter build: 设置UITableView代理的各种函数
    ///
    /// ⚠️注意1:调用此方法会将之前设定的delegate/dataSource/prefetchDataSource无效
    ///
    /// ⚠️注意2:设置build对应代理闭包的时候要谨防循环引用------请查看最上方说明
    public func bind(_ build: (ScrollViewBuilder.Table) -> ()) {
        let builder: ScrollViewBuilder.Table
        if let b = objc_getAssociatedObject(object, &JJ_ScrollView_Builder) as? ScrollViewBuilder.Table {
            builder = b
        } else {
            let b = ScrollViewBuilder.Table(manager: ScrollViewBuilder.Table.TabManager())
            objc_setAssociatedObject(object, &JJ_ScrollView_Builder, b, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            builder = b
        }
        build(builder)
        builder.build(for: object)
    }
}

extension JJ where Object: UICollectionView {
    /// 无需设置UICollectionView的代理,而直接通过闭包设置UITableView的delegate/dataSource/prefetchDataSource/CollectionDataDelegate
    ///
    /// - Parameter build: 设置UICollectionView代理的各种函数
    ///
    /// ⚠️注意1:调用此方法会将之前设定的delegate/dataSource/prefetchDataSource/CollectionDataDelegate无效
    ///
    /// ⚠️注意2:设置build对应代理闭包的时候要谨防循环引用------请查看最上方说明
    public func bind(_ build: (ScrollViewBuilder.Collection) -> ()) {
        let builder: ScrollViewBuilder.Collection
        if let b = objc_getAssociatedObject(object, &JJ_ScrollView_Builder) as? ScrollViewBuilder.Collection {
            builder = b
        } else {
            let b = ScrollViewBuilder.Collection(manager: ScrollViewBuilder.Collection.ColManager())
            objc_setAssociatedObject(object, &JJ_ScrollView_Builder, b, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            builder = b
        }
        build(builder)
        builder.build(for: object)
    }
}

extension JJ where Object: UIScrollView {
    /// 无需设定UIScrollView的代理,直接通过闭包设定UIScrollViewDelegate,
    /// 适用与UIScrollView以及只想观察UIScrollViewDelegate代理而非UITableViewDelegate/UICollectionViewDelegate
    ///
    /// 单独设定UIScrollViewDelegate代理函数,比如UITableView/UICollectionView调用此函数则会使用UIScrollViewDelegate的代理
    /// ，而无法设定对应的delegate/dataSource
    ///
    /// - Parameter build: 设置UIScrollView代理的各种函数
    public func bindOnlyScrollDelegate(_ build: (ScrollViewBuilder) -> ()) {
        let builder: ScrollViewBuilder
        if let b = objc_getAssociatedObject(object, &JJ_ScrollView_Builder) as? ScrollViewBuilder {
            builder = b
        } else {
            let b = ScrollViewBuilder(manager: ScrollViewBuilder.Manager())
            objc_setAssociatedObject(object, &JJ_ScrollView_Builder, b, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            builder = b
        }
        build(builder)
        builder.build(for: object)
    }
}
