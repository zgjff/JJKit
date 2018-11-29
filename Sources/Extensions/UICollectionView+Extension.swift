import UIKit

private var colleDelegateManagerKey: Void?
extension JJ where Original: UICollectionView {
    public weak var dataSourceDelegate: CollectionViewDelegateManager? {
        get {
            if let manager = objc_getAssociatedObject(original, &colleDelegateManagerKey) as? CollectionViewDelegateManager {
                return manager
            }
            let manager = CollectionViewDelegateManager(collectionView: original)
            objc_setAssociatedObject(original, &colleDelegateManagerKey, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return manager
        }
        set {
            objc_setAssociatedObject(original, &colleDelegateManagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public final class CollectionViewDelegateManager {
    private unowned let collectionView: UICollectionView
    private var delegate: CollectionViewDataDelegate?
    init?(collectionView: UICollectionView, delegate: CollectionViewDataDelegate = CollectionViewDataDelegate()) {
        guard collectionView.delegate == nil, collectionView.dataSource == nil else {
            return nil
        }
        self.collectionView = collectionView
        self.delegate = delegate
        delegate.delegateManager = self
    }
    
    public func bind() {
        collectionView.delegate = nil
        collectionView.dataSource = nil
        collectionView.delegate = delegate
        collectionView.dataSource = delegate
        guard #available(iOS 10.0, *) else {
            return
        }
        let prefetch = delegate?.responds(to: #selector(delegate?.collectionView(_:prefetchItemsAt:))) ?? false
        let cancelPrefetching = delegate?.responds(to: #selector(delegate?.collectionView(_:cancelPrefetchingForItemsAt:))) ?? false
        if prefetch || cancelPrefetching {
            collectionView.prefetchDataSource = nil
            collectionView.prefetchDataSource = delegate
        }
    }
}

extension CollectionViewDelegateManager {
    @discardableResult
    public func numberOfSections(_ block: @escaping () -> Int) -> Self {
        delegate?.numberOfSections = block
        return self
    }
    @discardableResult
    public func numberOfItemsInSection(_ block: @escaping (_ section: Int) -> Int) -> Self {
        delegate?.numberOfItems = block
        return self
    }
    @discardableResult
    public func cellForItem(_ block: @escaping (_ collectionView: UICollectionView,_ indexPath: IndexPath) -> UICollectionViewCell) -> Self {
        delegate?.cellForItem = block
        return self
    }
    @discardableResult
    public func viewForSupplementaryElement(_ block: @escaping (_ collectionView: UICollectionView, _ kind: UICollectionElementKind, _ indexPath: IndexPath) -> UICollectionReusableView?) -> Self {
        delegate?.viewForSupplementaryElement = block
        return self
    }
    @discardableResult
    public func canMoveItem(_ block: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        delegate?.canMoveItem = block
        return self
    }
    @discardableResult
    public func canMoveItem(_ block: @escaping (_ source: IndexPath, _ destination: IndexPath) -> ()) -> Self {
        delegate?.moveItem = block
        return self
    }
    @discardableResult
    public func shouldSelectItem(_ block: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        delegate?.shouldSelectItem = block
        return self
    }
    @discardableResult
    public func didSelectItem(_ block: @escaping (_ indexPath: IndexPath) -> ()) -> Self {
        delegate?.didSelectItem = block
        return self
    }
    @discardableResult
    public func shouldDeselectItem(_ block: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        delegate?.shouldDeselectItem = block
        return self
    }
    @discardableResult
    public func didDeselectItem(_ block: @escaping (_ indexPath: IndexPath) -> ()) -> Self {
        delegate?.didDeselectItem = block
        return self
    }
    @discardableResult
    public func willDisplayCell(_ block: @escaping (_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> ()) -> Self {
        delegate?.willDisplayCell = block
        return self
    }
    @discardableResult
    public func didEndDisplayCell(_ block: @escaping (_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> ()) -> Self {
        delegate?.didEndDisplayCell = block
        return self
    }
    @discardableResult
    public func willDisplaySupplementaryView(_ block: @escaping (_ view: UICollectionReusableView, _ kind: UICollectionElementKind, _ indexPath: IndexPath) -> ()) -> Self {
        delegate?.willDisplaySupplementaryView = block
        return self
    }
    @discardableResult
    public func didEndDisplaySupplementaryView(_ block: @escaping (_ view: UICollectionReusableView, _ kind: UICollectionElementKind, _ indexPath: IndexPath) -> ()) -> Self {
        delegate?.didEndDisplaySupplementaryView = block
        return self
    }
    @discardableResult
    public func prefetchItemsAt(_ block: @escaping (_ indexPaths: [IndexPath]) -> ()) -> Self {
        if #available(iOS 10.0, *) {
            delegate?.prefetchItems = block
        }
        return self
    }
    @discardableResult
    public func cancelPrefetchingItems(_ block: @escaping (_ indexPaths: [IndexPath]) -> ()) -> Self {
        if #available(iOS 10.0, *) {
            delegate?.cancelPrefetchingItems = block
        }
        return self
    }
    @discardableResult
    public func sizeForItem(_ block: @escaping (_ layout: UICollectionViewLayout, _ indexPath: IndexPath) -> CGSize) -> Self {
        delegate?.sizeForItem = block
        return self
    }
    @discardableResult
    public func insetForSection(_ block: @escaping (_ layout: UICollectionViewLayout, _ section: Int) -> UIEdgeInsets) -> Self {
        delegate?.insetForSection = block
        return self
    }
    @discardableResult
    public func minimumLineSpacingForSection(_ block: @escaping (_ layout: UICollectionViewLayout, _ section: Int) -> CGFloat) -> Self {
        delegate?.minimumLineSpacing = block
        return self
    }
    @discardableResult
    public func minimumInteritemSpacingForSection(_ block: @escaping (_ layout: UICollectionViewLayout, _ section: Int) -> CGFloat) -> Self {
        delegate?.minimumInteritemSpacing = block
        return self
    }
    @discardableResult
    public func referenceSizeForHeader(_ block: @escaping (_ layout: UICollectionViewLayout, _ section: Int) -> CGSize) -> Self {
        delegate?.referenceSizeForHeader = block
        return self
    }
    @discardableResult
    public func referenceSizeForFooter(_ block: @escaping (_ layout: UICollectionViewLayout, _ section: Int) -> CGSize) -> Self {
        delegate?.referenceSizeForFooter = block
        return self
    }
}


final class CollectionViewDataDelegate: NSObject {
    // UICollectionViewDataSource
    var numberOfSections: (() -> Int)?
    var numberOfItems: ((_ section: Int) -> Int)?
    var cellForItem: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell)?
    var viewForSupplementaryElement: ((_ collectionView: UICollectionView, _ kind: UICollectionElementKind, _ indexPath: IndexPath) -> UICollectionReusableView?)?
    var canMoveItem: ((_ indexPath: IndexPath) -> Bool)?
    var moveItem: ((_ source: IndexPath, _ destination: IndexPath) -> ())?
    // UICollectionViewDelegate
    var shouldSelectItem: ((_ indexPath: IndexPath) -> Bool)?
    var didSelectItem: ((_ indexPath: IndexPath) -> ())?
    var shouldDeselectItem: ((_ indexPath: IndexPath) -> Bool)?
    var didDeselectItem: ((_ indexPath: IndexPath) -> ())?
    var willDisplayCell: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> ())?
    var didEndDisplayCell: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> ())?
    var willDisplaySupplementaryView: ((_ view: UICollectionReusableView, _ kind: UICollectionElementKind, _ indexPath: IndexPath) -> ())?
    var didEndDisplaySupplementaryView: ((_ view: UICollectionReusableView, _ kind: UICollectionElementKind, _ indexPath: IndexPath) -> ())?
    // UICollectionViewDataSourcePrefetching
    var prefetchItems: ((_ indexPaths: [IndexPath]) -> ())?
    var cancelPrefetchingItems: ((_ indexPaths: [IndexPath]) -> ())?
    // UICollectionViewDelegateFlowLayout
    var sizeForItem: ((_ layout: UICollectionViewLayout, _ indexPath: IndexPath) -> CGSize)?
    var insetForSection: ((_ layout: UICollectionViewLayout, _ section: Int) -> UIEdgeInsets)?
    var minimumLineSpacing: ((_ layout: UICollectionViewLayout, _ section: Int) -> CGFloat)?
    var minimumInteritemSpacing: ((_ layout: UICollectionViewLayout, _ section: Int) -> CGFloat)?
    var referenceSizeForHeader: ((_ layout: UICollectionViewLayout, _ section: Int) -> CGSize)?
    var referenceSizeForFooter: ((_ layout: UICollectionViewLayout, _ section: Int) -> CGSize)?
    weak var delegateManager: CollectionViewDelegateManager?
    
    public override init() {
        super.init()
    }
}

extension CollectionViewDataDelegate {
    override func responds(to aSelector: Selector!) -> Bool {
        switch aSelector {
        // UICollectionViewDataSource
        case #selector(CollectionViewDataDelegate.numberOfSections(in:)):
            return numberOfSections != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:numberOfItemsInSection:)):
            return numberOfItems != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:cellForItemAt:)):
            return cellForItem != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:viewForSupplementaryElementOfKind:at:)):
            return viewForSupplementaryElement != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:canMoveItemAt:)):
            return canMoveItem != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:moveItemAt:to:)):
            return moveItem != nil
        // UICollectionViewDelegate
        case #selector(CollectionViewDataDelegate.collectionView(_:shouldSelectItemAt:)):
            return shouldSelectItem != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:didSelectItemAt:)):
            return didSelectItem != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:shouldDeselectItemAt:)):
            return shouldDeselectItem != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:didDeselectItemAt:)):
            return didDeselectItem != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:willDisplay:forItemAt:)):
            return willDisplayCell != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:didEndDisplaying:forItemAt:)):
            return didEndDisplayCell != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:willDisplaySupplementaryView:forElementKind:at:)):
            return willDisplaySupplementaryView != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:didEndDisplayingSupplementaryView:forElementOfKind:at:)):
            return didEndDisplaySupplementaryView != nil
        // UICollectionViewDataSourcePrefetching
        case #selector(CollectionViewDataDelegate.collectionView(_:prefetchItemsAt:)):
            return prefetchItems != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:cancelPrefetchingForItemsAt:)):
            return cancelPrefetchingItems != nil
        //  UICollectionViewDelegateFlowLayout
        case #selector(CollectionViewDataDelegate.collectionView(_:layout:sizeForItemAt:)):
            return sizeForItem != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:layout:insetForSectionAt:)):
            return insetForSection != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:layout:minimumLineSpacingForSectionAt:)):
            return minimumLineSpacing != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:layout:minimumInteritemSpacingForSectionAt:)):
            return minimumInteritemSpacing != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:layout:referenceSizeForHeaderInSection:)):
            return referenceSizeForHeader != nil
        case #selector(CollectionViewDataDelegate.collectionView(_:layout:referenceSizeForFooterInSection:)):
            return referenceSizeForFooter != nil
        default:
            return super.responds(to: aSelector)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionViewDataDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return shouldSelectItem?(indexPath) ?? true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem?(indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return shouldDeselectItem?(indexPath) ?? true
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        didDeselectItem?(indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayCell?(cell, indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        didEndDisplayCell?(cell, indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        let k = UICollectionElementKind(string: elementKind)
        willDisplaySupplementaryView?(view, k, indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        let k = UICollectionElementKind(string: elementKind)
        didEndDisplaySupplementaryView?(view, k, indexPath)
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
    public var kind: String {
        switch self {
         case .header: return UICollectionView.elementKindSectionHeader
         case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewDataDelegate: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections?() ?? 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems?(section) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellForItem?(collectionView, indexPath) ?? UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let k = UICollectionElementKind(string: kind)
        return viewForSupplementaryElement?(collectionView, k, indexPath) ?? UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return canMoveItem?(indexPath) ?? true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveItem?(sourceIndexPath, destinationIndexPath)
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension CollectionViewDataDelegate: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        prefetchItems?(indexPaths)
    }
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        cancelPrefetchingItems?(indexPaths)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewDataDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem?(collectionViewLayout, indexPath) ?? .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetForSection?(collectionViewLayout, section) ?? .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing?(collectionViewLayout, section) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing?( collectionViewLayout, section) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return referenceSizeForHeader?(collectionViewLayout, section) ?? .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return referenceSizeForFooter?(collectionViewLayout, section) ?? .zero
    }
}

