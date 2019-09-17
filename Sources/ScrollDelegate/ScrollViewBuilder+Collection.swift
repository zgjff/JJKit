import UIKit
extension ScrollViewBuilder {
    public class Collection: ScrollViewBuilder {
        private unowned var _manager: ScrollViewBuilder.Collection.ColManager! {
            return manager as? ScrollViewBuilder.Collection.ColManager
        }
        /// 是否设定了prefetchDataSource代理,默认是false
        private var isConfigDataSourcePrefetching = false
        internal func build(for collectionView: UICollectionView) {
            collectionView.delegate = nil
            collectionView.dataSource = nil
            collectionView.delegate = _manager
            collectionView.dataSource = _manager
            if #available(iOS 10.0, *) {
                if isConfigDataSourcePrefetching {
                    collectionView.prefetchDataSource = _manager
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
public extension ScrollViewBuilder.Collection {
    @discardableResult
    func shouldHighlightItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Bool) -> Self {
        _manager.shouldHighlightItem = block
        return self
    }
    @discardableResult
    func didHighlightItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.didHighlightItem = block
        return self
    }
    @discardableResult
    func didUnhighlightItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.didUnhighlightItem = block
        return self
    }
    @discardableResult
    func shouldSelectItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Bool) -> Self {
        _manager.shouldSelectItem = block
        return self
    }
    @discardableResult
    func shouldDeselectItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Bool) -> Self {
        _manager.shouldDeselectItem = block
        return self
    }
    @discardableResult
    func didSelectItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.didSelectItem = block
        return self
    }
    @discardableResult
    func didDeselectItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.didDeselectItem = block
        return self
    }
    @discardableResult
    func willDisplayCell(_ block: @escaping (_ collectionView: UICollectionView, _ cell: UICollectionViewCell, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.willDisplayCell = block
        return self
    }
    @discardableResult
    func willDisplaySupplementaryView(_ block: @escaping (_ collectionView: UICollectionView, _ view: UICollectionReusableView, _ kind: UICollectionElementKind, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.willDisplaySupplementaryView = block
        return self
    }
    @discardableResult
    func didEndDisplayingCell(_ block: @escaping (_ collectionView: UICollectionView, _ cell: UICollectionViewCell, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.didEndDisplayingCell = block
        return self
    }
    @discardableResult
    func didEndDisplayingSupplementaryView(_ block: @escaping (_ collectionView: UICollectionView, _ view: UICollectionReusableView, _ kind: UICollectionElementKind, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.didEndDisplayingSupplementaryView = block
        return self
    }
    @discardableResult
    func shouldShowMenuForItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Bool) -> Self {
        _manager.shouldShowMenuForItem = block
        return self
    }
    @discardableResult
    func canPerformAction(_ block: @escaping (_ collectionView: UICollectionView, _ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> Bool) -> Self {
        _manager.canPerformAction = block
        return self
    }
    @discardableResult
    func performAction(_ block: @escaping (_ collectionView: UICollectionView, _ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> ()) -> Self {
        _manager.performAction = block
        return self
    }
    @discardableResult
    func transitionLayout(_ block: @escaping (_ collectionView: UICollectionView, _ fromLayout: UICollectionViewLayout, _ newLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout) -> Self {
        _manager.transitionLayout = block
        return self
    }
    @discardableResult
    func canFocusItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Bool) -> Self {
        _manager.canFocusItem = block
        return self
    }
    @discardableResult
    func shouldUpdateFocus(_ block: @escaping (_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext) -> Bool) -> Self {
        _manager.shouldUpdateFocus = block
        return self
    }
    @discardableResult
    func didUpdateFocus(_ block: @escaping (_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> ()) -> Self {
        _manager.didUpdateFocus = block
        return self
    }
    @discardableResult
    func indexPathForPreferredFocusedView(_ block: @escaping (_ collectionView: UICollectionView) -> IndexPath?) -> Self {
        _manager.indexPathForPreferredFocusedView = block
        return self
    }
    @discardableResult
    func targetContentOffset(_ block: @escaping (_ collectionView: UICollectionView, _ proposedContentOffset: CGPoint) -> CGPoint) -> Self {
        _manager.targetContentOffset = block
        return self
    }
    @discardableResult
    func targetIndexPathForMove(_ block: @escaping (_ collectionView: UICollectionView, _ originalIndexPath: IndexPath, _ proposedIndexPath: IndexPath) -> IndexPath) -> Self {
        _manager.targetIndexPathForMove = block
        return self
    }
    @available(iOS 11.0, *)
    @discardableResult
    func shouldSpringLoadItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath, _ context: UISpringLoadedInteractionContext) -> Bool) -> Self {
        _manager.shouldSpringLoadItem = block
        return self
    }
}

// MARK: - UICollectionViewDataSource
public extension ScrollViewBuilder.Collection {
    @discardableResult
    func numberOfItems(_ block: @escaping (_ collectionView: UICollectionView, _ section: Int) -> Int) -> Self {
        _manager.numberOfItems = block
        return self
    }
    @discardableResult
    func numberOfSections(_ block: @escaping (_ collectionView: UICollectionView) -> Int) -> Self {
        _manager.numberOfSections = block
        return self
    }
    @discardableResult
    func cellForItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell) -> Self {
        _manager.cellForItem = block
        return self
    }
    @discardableResult
    func viewForSupplementaryElement(_ block: @escaping (_ collectionView: UICollectionView, _ kind: UICollectionElementKind, _ indexPath: IndexPath) -> UICollectionReusableView) -> Self {
        _manager.viewForSupplementaryElement = block
        return self
    }
    @discardableResult
    func canMoveItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Bool) -> Self {
        _manager.canMoveItem = block
        return self
    }
    @discardableResult
    func moveItem(_ block: @escaping (_ collectionView: UICollectionView, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> ()) -> Self {
        _manager.moveItem = block
        return self
    }
    @discardableResult
    func indexTitles(_ block: @escaping (_ collectionView: UICollectionView) -> [String]?) -> Self {
        _manager.indexTitles = block
        return self
    }
    @discardableResult
    func indexPathForIndexTitle(_ block: @escaping (_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath) -> Self {
        _manager.indexPathForIndexTitle = block
        return self
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
public extension ScrollViewBuilder.Collection {
    @available(iOS 10.0, *)
    @discardableResult
    func prefetchItems(_ block: @escaping (_ collectionView: UICollectionView, _ indexPaths: [IndexPath]) -> ()) -> Self {
        isConfigDataSourcePrefetching = true
        _manager.prefetchItems = block
        return self
    }
    @available(iOS 10.0, *)
    @discardableResult
    func cancelPrefetchingForItems(_ block: @escaping (_ collectionView: UICollectionView, _ indexPaths: [IndexPath]) -> ()) -> Self {
        isConfigDataSourcePrefetching = true
        _manager.cancelPrefetchingForItems = block
        return self
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
public extension ScrollViewBuilder.Collection {
    @discardableResult
    func sizeForItem(_ block: @escaping (_ collectionView: UICollectionView, _ layout: UICollectionViewLayout, _ indexPath: IndexPath) -> CGSize) -> Self {
        _manager.sizeForItem = block
        return self
    }
    @discardableResult
    func insetForSection(_ block: @escaping (_ collectionView: UICollectionView, _ layout: UICollectionViewLayout, _ section: Int) -> UIEdgeInsets) -> Self {
        _manager.insetForSection = block
        return self
    }
    @discardableResult
    func minimumLineSpacingForSection(_ block: @escaping (_ collectionView: UICollectionView, _ layout: UICollectionViewLayout, _ section: Int) -> CGFloat) -> Self {
        _manager.minimumLineSpacingForSection = block
        return self
    }
    @discardableResult
    func minimumInteritemSpacingForSection(_ block: @escaping (_ collectionView: UICollectionView, _ layout: UICollectionViewLayout, _ section: Int) -> CGFloat) -> Self {
        _manager.minimumInteritemSpacingForSection = block
        return self
    }
    @discardableResult
    func referenceSizeForHeaderInSection(_ block: @escaping (_ collectionView: UICollectionView, _ layout: UICollectionViewLayout, _ section: Int) -> CGSize) -> Self {
        _manager.referenceSizeForHeader = block
        return self
    }
    @discardableResult
    func referenceSizeForFooterInSection(_ block: @escaping (_ collectionView: UICollectionView, _ layout: UICollectionViewLayout, _ section: Int) -> CGSize) -> Self {
        _manager.referenceSizeForFooter = block
        return self
    }
}
