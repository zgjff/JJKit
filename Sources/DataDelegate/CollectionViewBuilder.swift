import UIKit

public class CollectionViewBuilder: ScrollViewBuilder {
    private unowned var _manager: CollectionDataDelegate! {
        return manager as? CollectionDataDelegate
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

// MARK: - UICollectionViewDelegate
public extension CollectionViewBuilder {
    func shouldHighlightItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Bool) {
        _manager.shouldHighlightItem = block
    }
    func didHighlightItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> ()) {
        _manager.didHighlightItem = block
    }
    func didUnhighlightItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> ()) {
        _manager.didUnhighlightItem = block
    }
    func shouldSelectItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Bool) {
        _manager.shouldSelectItem = block
    }
    func shouldDeselectItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Bool) {
        _manager.shouldDeselectItem = block
    }
    func didSelectItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> ()) {
        _manager.didSelectItem = block
    }
    func didDeselectItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> ()) {
        _manager.didDeselectItem = block
    }
    func willDisplayCell(_ block: @escaping (_ collectionView: UICollectionView, _ cell: UICollectionViewCell, _ indexPath: IndexPath) -> ()) {
        _manager.willDisplayCell = block
    }
    func willDisplaySupplementaryView(_ block: @escaping (_ collectionView: UICollectionView, _ view: UICollectionReusableView, _ kind: UICollectionElementKind, _ indexPath: IndexPath) -> ()) {
        _manager.willDisplaySupplementaryView = block
    }
    func didEndDisplayingCell(_ block: @escaping (_ collectionView: UICollectionView, _ cell: UICollectionViewCell, _ indexPath: IndexPath) -> ()) {
        _manager.didEndDisplayingCell = block
    }
    func didEndDisplayingSupplementaryView(_ block: @escaping (_ collectionView: UICollectionView, _ view: UICollectionReusableView, _ kind: UICollectionElementKind, _ indexPath: IndexPath) -> ()) {
        _manager.didEndDisplayingSupplementaryView = block
    }
    func shouldShowMenuForItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Bool) {
        _manager.shouldShowMenuForItem = block
    }
    func canPerformAction(_ block: @escaping (_ collectionView: UICollectionView, _ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> Bool) {
        _manager.canPerformAction = block
    }
    func performAction(_ block: @escaping (_ collectionView: UICollectionView, _ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> ()) {
        _manager.performAction = block
    }
    func transitionLayout(_ block: @escaping (_ collectionView: UICollectionView, _ fromLayout: UICollectionViewLayout, _ newLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout) {
        _manager.transitionLayout = block
    }
    func canFocusItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Bool) {
        _manager.canFocusItem = block
    }
    func shouldUpdateFocus(_ block: @escaping (_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext) -> Bool) {
        _manager.shouldUpdateFocus = block
    }
    func didUpdateFocus(_ block: @escaping (_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> ()) {
        _manager.didUpdateFocus = block
    }
    func indexPathForPreferredFocusedView(_ block: @escaping (_ collectionView: UICollectionView) -> IndexPath?) {
        _manager.indexPathForPreferredFocusedView = block
    }
    func targetContentOffset(_ block: @escaping (_ collectionView: UICollectionView, _ proposedContentOffset: CGPoint) -> CGPoint) {
        _manager.targetContentOffset = block
    }
    func targetIndexPathForMove(_ block: @escaping (_ collectionView: UICollectionView, _ originalIndexPath: IndexPath, _ proposedIndexPath: IndexPath) -> IndexPath) {
        _manager.targetIndexPathForMove = block
    }
    @available(iOS 11.0, *)
    func shouldSpringLoadItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath, _ context: UISpringLoadedInteractionContext) -> Bool) {
        _manager.shouldSpringLoadItem = block
    }
}

// MARK: - UICollectionViewDataSource
public extension CollectionViewBuilder {
    func numberOfItems(_ block: @escaping (_ collectionView: UICollectionView, _ section: Int) -> Int) {
        _manager.numberOfItems = block
    }
    func numberOfSections(_ block: @escaping (_ collectionView: UICollectionView) -> Int) {
        _manager.numberOfSections = block
    }
    func cellForItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell) {
        _manager.cellForItem = block
    }
    func viewForSupplementaryElement(_ block: @escaping (_ collectionView: UICollectionView, _ kind: UICollectionElementKind, _ indexPath: IndexPath) -> UICollectionViewCell) {
        _manager.viewForSupplementaryElement = block
    }
    func canMoveItem(_ block: @escaping (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Bool) {
        _manager.canMoveItem = block
    }
    func moveItem(_ block: @escaping (_ collectionView: UICollectionView, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> ()) {
        _manager.moveItem = block
    }
    func indexTitles(_ block: @escaping (_ collectionView: UICollectionView) -> [String]?) {
        _manager.indexTitles = block
    }
    func indexPathForIndexTitle(_ block: @escaping (_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath) {
        _manager.indexPathForIndexTitle = block
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
public extension CollectionViewBuilder {
    @available(iOS 10.0, *)
    func prefetchItems(_ block: @escaping (_ collectionView: UICollectionView, _ indexPaths: [IndexPath]) -> ()) {
        _manager.prefetchItems = block
    }
    @available(iOS 10.0, *)
    func cancelPrefetchingForItems(_ block: @escaping (_ collectionView: UICollectionView, _ indexPaths: [IndexPath]) -> ()) {
        _manager.cancelPrefetchingForItems = block
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
public extension CollectionViewBuilder {
    func sizeForItem(_ block: @escaping (_ collectionView: UICollectionView, _ layout: UICollectionViewLayout, _ indexPath: IndexPath) -> CGSize) {
        _manager.sizeForItem = block
    }
    func insetForSection(_ block: @escaping (_ collectionView: UICollectionView, _ layout: UICollectionViewLayout, _ section: Int) -> UIEdgeInsets) {
        _manager.insetForSection = block
    }
    func minimumLineSpacingForSection(_ block: @escaping (_ collectionView: UICollectionView, _ layout: UICollectionViewLayout, _ section: Int) -> CGFloat) {
        _manager.minimumLineSpacingForSection = block
    }
    func minimumInteritemSpacingForSection(_ block: @escaping (_ collectionView: UICollectionView, _ layout: UICollectionViewLayout, _ section: Int) -> CGFloat) {
        _manager.minimumInteritemSpacingForSection = block
    }
    func referenceSizeForHeaderInSection(_ block: @escaping (_ collectionView: UICollectionView, _ layout: UICollectionViewLayout, _ section: Int) -> CGSize) {
        _manager.referenceSizeForHeader = block
    }
    func referenceSizeForFooterInSection(_ block: @escaping (_ collectionView: UICollectionView, _ layout: UICollectionViewLayout, _ section: Int) -> CGSize) {
        _manager.referenceSizeForFooter = block
    }
}
