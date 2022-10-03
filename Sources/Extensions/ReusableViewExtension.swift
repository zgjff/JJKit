//
//  ReusableViewExtension.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

protocol JJReusableViewable: NSObjectProtocol {
    static var jj_defaultReuseIdentifier: String { get }
}

extension JJReusableViewable where Self: UIView {
    static var jj_defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: JJReusableViewable {}
extension UITableViewHeaderFooterView: JJReusableViewable {}

extension JJBox where Base: UITableView {
    /// 加载可重复使用的UITableViewCell
    /// 使用此方法无需registerCell
    /// - Parameter initialize: UITableViewCell 的初始化
    /// - Returns: UITableViewCell
    func dequeueReusableCell<T>(initialize: ((String) -> T)? = nil) -> T where T: UITableViewCell {
        func initCell() -> T {
            return initialize?(T.jj_defaultReuseIdentifier) ?? T(style: .default, reuseIdentifier: T.jj_defaultReuseIdentifier)
        }
        let cell = base.dequeueReusableCell(withIdentifier: T.jj_defaultReuseIdentifier) as? T ?? initCell()
        return cell
    }
    
    /// 加载可重复使用的UITableViewHeaderFooterView
    /// 使用此方法无需registerHeaderFooterView
    /// - Parameter initialize: UITableViewHeaderFooterView 的初始化
    /// - Returns: UITableViewHeaderFooterView
    func dequeueReusableHeaderFooterView<T>(initialize: ((String) -> T)? = nil) -> T where T: UITableViewHeaderFooterView {
        func initView() -> T {
            return initialize?(T.jj_defaultReuseIdentifier) ?? T()
        }
        let view = base.dequeueReusableHeaderFooterView(withIdentifier: T.jj_defaultReuseIdentifier) as? T ?? initView()
        return view
    }
}

extension UICollectionReusableView: JJReusableViewable {}

extension JJBox where Base: UICollectionView {
    func registerCell<T>(_: T.Type) where T: UICollectionViewCell {
        base.register(T.self, forCellWithReuseIdentifier: T.jj_defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T>(for indexPath: IndexPath) -> T where T: UICollectionViewCell{
        guard let cell = base.dequeueReusableCell(withReuseIdentifier: T.jj_defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.jj_defaultReuseIdentifier)")
        }
        return cell
    }
    
    func registerSupplementaryView<T>(_: T.Type, forkind kind: UICollectionElementKind) where T: UICollectionReusableView {
        base.register(T.self, forSupplementaryViewOfKind: kind.kind, withReuseIdentifier: T.jj_defaultReuseIdentifier)
    }
    
    func dequeueSupplementaryView<T>(for kind: UICollectionElementKind, indexPath: IndexPath) -> T where T: UICollectionReusableView {
        guard let cell = base.dequeueReusableSupplementaryView(ofKind: kind.kind, withReuseIdentifier: T.jj_defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue SupplementaryView with identifier: \(T.jj_defaultReuseIdentifier)")
        }
        return cell
    }
}

public enum UICollectionElementKind {
    case header, footer
    init(string: String) {
        switch string {
        case UICollectionView.elementKindSectionHeader: self = .header
        case UICollectionView.elementKindSectionFooter: self = .footer
        default: self = .header
        }
    }
    
    var kind: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}
