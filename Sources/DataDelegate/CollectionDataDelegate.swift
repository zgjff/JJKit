import UIKit

internal class CollectionDataDelegate: ScrollDelegateManager {
    // MARK: - UICollectionViewDelegate
    internal var shouldHighlightItem: ((UICollectionView, IndexPath) -> Bool)?
    internal var didHighlightItem: ((UICollectionView, IndexPath) -> ())?
    internal var didUnhighlightItem: ((UICollectionView, IndexPath) -> ())?
    internal var shouldSelectItem: ((UICollectionView, IndexPath) -> Bool)?
    internal var shouldDeselectItem: ((UICollectionView, IndexPath) -> Bool)?
    internal var didSelectItem: ((UICollectionView, IndexPath) -> ())?
    internal var didDeselectItem: ((UICollectionView, IndexPath) -> ())?
    internal var willDisplayCell: ((UICollectionView, UICollectionViewCell, IndexPath) -> ())?
    internal var willDisplaySupplementaryView: ((UICollectionView, UICollectionReusableView, UICollectionElementKind, IndexPath) -> ())?
    internal var didEndDisplayingCell: ((UICollectionView, UICollectionViewCell, IndexPath) -> ())?
    internal var didEndDisplayingSupplementaryView: ((UICollectionView, UICollectionReusableView, UICollectionElementKind, IndexPath) -> ())?
    internal var shouldShowMenuForItem: ((UICollectionView, IndexPath) -> Bool)?
    internal var canPerformAction: ((UICollectionView, Selector, IndexPath, Any?) -> Bool)?
    internal var performAction: ((UICollectionView, Selector, IndexPath, Any?) -> ())?
    internal var transitionLayout: ((UICollectionView, UICollectionViewLayout, UICollectionViewLayout) -> UICollectionViewTransitionLayout)?
    internal var canFocusItem: ((UICollectionView, IndexPath) -> Bool)?
    internal var shouldUpdateFocus: ((UICollectionView, UICollectionViewFocusUpdateContext) -> Bool)?
    internal var didUpdateFocus: ((UICollectionView, UICollectionViewFocusUpdateContext, UIFocusAnimationCoordinator) -> ())?
    internal var indexPathForPreferredFocusedView: ((UICollectionView) -> IndexPath?)?
    internal var targetContentOffset: ((UICollectionView, CGPoint) -> CGPoint)?
    internal var targetIndexPathForMove: ((UICollectionView, IndexPath, IndexPath) -> IndexPath)?
    private var _shouldSpringLoadItem: Any?
    @available(iOS 11, *)
    internal var shouldSpringLoadItem: ((UICollectionView, IndexPath, UISpringLoadedInteractionContext) -> Bool)? {
        get {
            return _shouldSpringLoadItem as? (UICollectionView, IndexPath, UISpringLoadedInteractionContext) -> Bool
        }
        set {
            _shouldSpringLoadItem = newValue
        }
    }
    
    // MARK: - UICollectionViewDataSource
    internal var numberOfItems: ((UICollectionView, Int) -> Int)?
    internal var numberOfSections: ((UICollectionView) -> Int)?
    internal var cellForItem: ((UICollectionView, IndexPath) -> UICollectionViewCell)?
    internal var viewForSupplementaryElement: ((UICollectionView, UICollectionElementKind, IndexPath) -> UICollectionReusableView)?
    internal var canMoveItem: ((UICollectionView, IndexPath) -> Bool)?
    internal var moveItem: ((UICollectionView, IndexPath, IndexPath) -> ())?
    internal var indexTitles: ((UICollectionView) -> [String]?)?
    internal var indexPathForIndexTitle: ((UICollectionView, String, Int) -> IndexPath)?
    
    // MARK: - UICollectionViewDataSourcePrefetching
    internal var prefetchItems: ((UICollectionView, [IndexPath]) -> ())?
    internal var cancelPrefetchingForItems: ((UICollectionView, [IndexPath]) -> ())?
    
    // MARK: - UICollectionViewDelegateFlowLayout
    internal var sizeForItem: ((UICollectionView, UICollectionViewLayout, IndexPath) -> CGSize)?
    internal var insetForSection: ((UICollectionView, UICollectionViewLayout, Int) -> UIEdgeInsets)?
    internal var minimumLineSpacingForSection: ((UICollectionView, UICollectionViewLayout, Int) -> CGFloat)?
    internal var minimumInteritemSpacingForSection: ((UICollectionView, UICollectionViewLayout, Int) -> CGFloat)?
    internal var referenceSizeForHeader: ((UICollectionView, UICollectionViewLayout, Int) -> CGSize)?
    internal var referenceSizeForFooter: ((UICollectionView, UICollectionViewLayout, Int) -> CGSize)?
}

// MARK: - UICollectionViewDelegate
extension CollectionDataDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return shouldHighlightItem?(collectionView, indexPath) ?? true
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        didHighlightItem?(collectionView, indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        didUnhighlightItem?(collectionView, indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return shouldSelectItem?(collectionView, indexPath) ?? true
    }
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return shouldDeselectItem?(collectionView, indexPath) ?? true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem?(collectionView, indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        didDeselectItem?(collectionView, indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayCell?(collectionView, cell, indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        let kind = UICollectionElementKind(string: elementKind)
        willDisplaySupplementaryView?(collectionView, view, kind, indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        didEndDisplayingCell?(collectionView, cell, indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        let kind = UICollectionElementKind(string: elementKind)
        didEndDisplayingSupplementaryView?(collectionView, view, kind, indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return shouldShowMenuForItem?(collectionView, indexPath) ?? false
    }
    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return canPerformAction?(collectionView, action, indexPath, sender) ?? false
    }
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        performAction?(collectionView, action, indexPath, sender)
    }
    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        return transitionLayout?(collectionView, fromLayout, toLayout) ?? UICollectionViewTransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
    }
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return canFocusItem?(collectionView, indexPath) ?? false
    }
    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        return shouldUpdateFocus?(collectionView, context) ?? collectionView.shouldUpdateFocus(in: context)
    }
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        didUpdateFocus?(collectionView, context, coordinator)
    }
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return indexPathForPreferredFocusedView?(collectionView)
    }
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return targetContentOffset?(collectionView, proposedContentOffset) ?? proposedContentOffset
    }
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        return targetIndexPathForMove?(collectionView, originalIndexPath, proposedIndexPath) ?? proposedIndexPath
    }
    @available(iOS 11.0, *)
    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return shouldSpringLoadItem?(collectionView, indexPath, context) ?? true
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionDataDelegate: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems?(collectionView, section) ?? 0
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections?(collectionView) ?? 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellForItem?(collectionView, indexPath) ?? UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return viewForSupplementaryElement?(collectionView, UICollectionElementKind(string: kind), indexPath) ?? UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return canMoveItem?(collectionView, indexPath) ?? false
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveItem?(collectionView, sourceIndexPath, destinationIndexPath)
    }
    func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return indexTitles?(collectionView)
    }
    func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        return indexPathForIndexTitle?(collectionView, title, index) ?? IndexPath(item: 0, section: 0)
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension CollectionDataDelegate: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        prefetchItems?(collectionView, indexPaths)
    }
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        cancelPrefetchingForItems?(collectionView, indexPaths)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionDataDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let sfi = sizeForItem {
            return sfi(collectionView, collectionViewLayout, indexPath)
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.itemSize
        }
        if let att = collectionViewLayout.layoutAttributesForItem(at: indexPath) {
            return att.size
        }
        return  .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let ifs = insetForSection {
            return ifs(collectionView, collectionViewLayout, section)
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.sectionInset
        }
        return  .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let msf = minimumLineSpacingForSection {
            return msf(collectionView, collectionViewLayout, section)
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.minimumLineSpacing
        }
        return  0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let mis = minimumInteritemSpacingForSection {
            return mis(collectionView, collectionViewLayout, section)
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.minimumInteritemSpacing
        }
        return  0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let rsh = referenceSizeForHeader {
            return rsh(collectionView, collectionViewLayout, section)
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.headerReferenceSize
        }
        if let att = collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section)) {
            return att.size
        }
        return  .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let rsf = referenceSizeForFooter {
            return rsf(collectionView, collectionViewLayout, section)
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.headerReferenceSize
        }
        if let att = collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: section)) {
            return att.size
        }
        return  .zero
    }
}
