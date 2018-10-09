import UIKit

/// 注册uitableviewcell／uicollectionviewcell的协议
public protocol ReusableViewable: NSObjectProtocol {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableViewable where Self: UIView {
    public static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableViewable {}
extension UITableViewHeaderFooterView: ReusableViewable {}

extension UITableView {
    /// 加载可重复使用的UITableViewCell
    /// 使用此方法无需registerCell
    /// - Parameter initialize: UITableViewCell 的初始化
    /// - Returns: UITableViewCell
    public func dequeueReusableCell<T>(initialize: ((String) -> T)? = nil) -> T where T: UITableViewCell {
        func initCell() -> T {
            return initialize?(T.defaultReuseIdentifier) ?? T(style: .default, reuseIdentifier: T.defaultReuseIdentifier)
        }
        let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier) as? T ?? initCell()
        return cell
    }
    /// 加载可重复使用的UITableViewHeaderFooterView
    /// 使用此方法无需registerHeaderFooterView
    /// - Parameter initialize: UITableViewHeaderFooterView 的初始化
    /// - Returns: UITableViewHeaderFooterView
    public func dequeueReusableHeaderFooterView<T>(initialize: ((String) -> T)? = nil) -> T where T: UITableViewHeaderFooterView {
        func initView() -> T {
            return initialize?(T.defaultReuseIdentifier) ?? T()
        }
        let view = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T ?? initView()
        return view
    }
}

extension UICollectionReusableView: ReusableViewable {}
extension UICollectionView {
    public func registerCell<T>(_: T.Type) where T: UICollectionViewCell {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    public func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UICollectionViewCell{
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    public func registerSupplementaryView<T>(_: T.Type, forkind kind: UICollectionElementKind) where T: UICollectionReusableView {
        register(T.self, forSupplementaryViewOfKind: kind.kind, withReuseIdentifier: T.defaultReuseIdentifier)
    }
    public func dequeueSupplementaryView<T>(for kind: UICollectionElementKind, indexPath: IndexPath) -> T where T: UICollectionReusableView {
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind.kind, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue SupplementaryView with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}
