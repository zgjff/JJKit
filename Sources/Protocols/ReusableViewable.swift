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

extension UITableView {
    public func dequeueReusableCell<T>(style: UITableViewCellStyle = .default) -> T where T: UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier) as? T ?? T(style: style, reuseIdentifier: T.defaultReuseIdentifier)
        return cell
    }
}

extension UICollectionViewCell: ReusableViewable {}

extension UICollectionView {
    public func register<T>(_: T.Type) where T: UICollectionViewCell {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    public func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UICollectionViewCell{
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}

