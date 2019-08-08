import UIKit

internal class TableDataDelegate: ScrollDelegateManager {
    // MARK: - UITableViewDelegate
    internal var willDisplayCell: ((UITableView, UITableViewCell, IndexPath) -> ())?
    internal var willDisplayHeaderView: ((UITableView, UIView, Int) -> ())?
    internal var willDisplayFooterView: ((UITableView, UIView, Int) -> ())?
    internal var didEndDisplayingCell: ((UITableView, UITableViewCell, IndexPath) -> ())?
    internal var didEndDisplayingHeaderView: ((UITableView, UIView, Int) -> ())?
    internal var didEndDisplayingFooterView: ((UITableView, UIView, Int) -> ())?
    internal var heightForRow: ((UITableView, IndexPath) -> CGFloat)?
    internal var heightForHeader: ((UITableView, Int) -> CGFloat)?
    internal var heightForFooter: ((UITableView, Int) -> CGFloat)?
    internal var estimatedHeightForRow: ((UITableView, IndexPath) -> CGFloat)?
    internal var estimatedHeightForHeader: ((UITableView, Int) -> CGFloat)?
    internal var estimatedHeightForFooter: ((UITableView, Int) -> CGFloat)?
    internal var viewForHeader: ((UITableView, Int) -> UIView?)?
    internal var viewForFooter: ((UITableView, Int) -> UIView?)?
    internal var accessoryButtonTappedForRow: ((UITableView, IndexPath) -> ())?
    internal var shouldHighlightRow: ((UITableView, IndexPath) -> Bool)?
    internal var didHighlightRow: ((UITableView, IndexPath) -> ())?
    internal var didUnhighlightRow: ((UITableView, IndexPath) -> ())?
    internal var willSelectRow: ((UITableView, IndexPath) -> IndexPath?)?
    internal var willDeselectRow: ((UITableView, IndexPath) -> IndexPath?)?
    internal var didSelectRow: ((UITableView, IndexPath) -> ())?
    internal var didDeselectRow: ((UITableView, IndexPath) -> ())?
    internal var editingStyleForRow: ((UITableView, IndexPath) -> UITableViewCell.EditingStyle)?
    internal var titleForDeleteConfirmationButtonForRow: ((UITableView, IndexPath) -> String?)?
    internal var editActionsForRow: ((UITableView, IndexPath) -> [UITableViewRowAction]?)?
    private var _leadingSwipeActionsConfigurationForRow: Any?
    @available(iOS 11, *)
    internal var leadingSwipeActionsConfigurationForRow: ((UITableView, IndexPath) -> UISwipeActionsConfiguration?)? {
        get {
            return _leadingSwipeActionsConfigurationForRow as? (UITableView, IndexPath) -> UISwipeActionsConfiguration?
        }
        set {
            _leadingSwipeActionsConfigurationForRow = newValue
        }
    }
    private var _trailingSwipeActionsConfigurationForRow: Any?
    @available(iOS 11, *)
    internal var trailingSwipeActionsConfigurationForRow: ((UITableView, IndexPath) -> UISwipeActionsConfiguration?)? {
        get {
            return _trailingSwipeActionsConfigurationForRow as? (UITableView, IndexPath) -> UISwipeActionsConfiguration?
        }
        set {
            _trailingSwipeActionsConfigurationForRow = newValue
        }
    }
    internal var shouldIndentWhileEditingRow: ((UITableView, IndexPath) -> Bool)?
    internal var willBeginEditingRow: ((UITableView, IndexPath) -> ())?
    internal var didEndEditingRow: ((UITableView, IndexPath?) -> ())?
    internal var indexPathForMoveFromRow: ((UITableView, IndexPath, IndexPath) -> IndexPath)?
    internal var indentationLevelForRow: ((UITableView, IndexPath) -> Int)?
    internal var shouldShowMenuForRow: ((UITableView, IndexPath) -> Bool)?
    internal var canPerformAction: ((UITableView, Selector, IndexPath, Any?) -> Bool)?
    internal var performAction: ((UITableView, Selector, IndexPath, Any?) -> ())?
    internal var canFocusRow: ((UITableView, IndexPath) -> Bool)?
    internal var shouldUpdateFocus: ((UITableView, UITableViewFocusUpdateContext) -> Bool)?
    internal var didUpdateFocus: ((UITableView, UITableViewFocusUpdateContext, UIFocusAnimationCoordinator) -> ())?
    internal var indexPathForPreferredFocusedView: ((UITableView) -> IndexPath?)?
    private var _shouldSpringLoadRow: Any?
    @available(iOS 11, *)
    internal var shouldSpringLoadRow: ((UITableView, IndexPath, UISpringLoadedInteractionContext) -> Bool)? {
        get {
            return _shouldSpringLoadRow as? (UITableView, IndexPath, UISpringLoadedInteractionContext) -> Bool
        }
        set {
            _shouldSpringLoadRow = newValue
        }
    }
    
    // MARK: - UITableViewDataSource
    internal var numberOfRows: ((UITableView, Int) -> Int)?
    internal var cellForRow: ((UITableView, IndexPath) -> UITableViewCell)?
    internal var numberOfSections: ((UITableView) -> Int)?
    internal var titleForHeader: ((UITableView, Int) -> String)?
    internal var titleForFooter: ((UITableView, Int) -> String)?
    internal var canEditRow: ((UITableView, IndexPath) -> Bool)?
    internal var canMoveRow: ((UITableView, IndexPath) -> Bool)?
    internal var sectionForSectionIndexTitle: ((UITableView, String, Int) -> Int)?
    internal var commit: ((UITableView, UITableViewCell.EditingStyle, IndexPath) -> ())?
    internal var moveRow: ((UITableView, IndexPath, IndexPath) -> ())?
    
    // MARK: - UITableViewDataSourcePrefetching
    internal var prefetchRows: ((UITableView, [IndexPath]) -> ())?
    internal var cancelPrefetchingForRows: ((UITableView, [IndexPath]) -> ())?
}

// MARK: - UITableViewDelegate
extension TableDataDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplayCell?(tableView, cell, indexPath)
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        willDisplayHeaderView?(tableView, view, section)
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        willDisplayFooterView?(tableView, view, section)
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        didEndDisplayingCell?(tableView, cell, indexPath)
    }
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        didEndDisplayingHeaderView?(tableView, view, section)
    }
    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        didEndDisplayingFooterView?(tableView, view, section)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow?(tableView, indexPath) ?? tableView.rowHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader?(tableView, section) ?? tableView.sectionHeaderHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooter?(tableView, section) ?? tableView.sectionFooterHeight
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedHeightForRow?(tableView, indexPath) ?? tableView.estimatedRowHeight
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return estimatedHeightForHeader?(tableView, section) ?? tableView.estimatedSectionHeaderHeight
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return estimatedHeightForFooter?(tableView, section) ?? tableView.estimatedSectionFooterHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeader?(tableView, section)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForFooter?(tableView, section)
    }
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        accessoryButtonTappedForRow?(tableView, indexPath)
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return shouldHighlightRow?(tableView, indexPath) ?? true
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        didHighlightRow?(tableView, indexPath)
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        didUnhighlightRow?(tableView, indexPath)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return willSelectRow?(tableView, indexPath)
    }
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return willDeselectRow?(tableView, indexPath)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow?(tableView, indexPath)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselectRow?(tableView, indexPath)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return editingStyleForRow?(tableView, indexPath) ?? .none
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return titleForDeleteConfirmationButtonForRow?(tableView, indexPath)
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return editActionsForRow?(tableView, indexPath)
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return leadingSwipeActionsConfigurationForRow?(tableView, indexPath)
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return trailingSwipeActionsConfigurationForRow?(tableView, indexPath)
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return shouldIndentWhileEditingRow?(tableView, indexPath) ?? true
    }
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        willBeginEditingRow?(tableView, indexPath)
    }
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        didEndEditingRow?(tableView, indexPath)
    }
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return indexPathForMoveFromRow?(tableView, sourceIndexPath, proposedDestinationIndexPath) ?? proposedDestinationIndexPath
    }
    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return indentationLevelForRow?(tableView, indexPath) ?? 0
    }
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return shouldShowMenuForRow?(tableView, indexPath) ?? false
    }
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return canPerformAction?(tableView, action, indexPath, sender) ?? false
    }
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        performAction?(tableView, action, indexPath, sender)
    }
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return canFocusRow?(tableView, indexPath) ?? false
    }
    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return shouldUpdateFocus?(tableView, context) ?? tableView.shouldUpdateFocus(in: context)
    }
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        didUpdateFocus?(tableView, context, coordinator)
    }
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return indexPathForPreferredFocusedView?(tableView)
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return shouldSpringLoadRow?(tableView, indexPath, context) ?? true
    }
}

// MARK: - UITableViewDataSource
extension TableDataDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows?(tableView, section) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRow?(tableView, indexPath) ?? UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections?(tableView) ?? 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeader?(tableView, section)
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return titleForFooter?(tableView, section)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return canEditRow?(tableView, indexPath) ?? true
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return canMoveRow?(tableView, indexPath) ?? true
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionForSectionIndexTitle?(tableView, title, index) ?? 0
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        commit?(tableView, editingStyle, indexPath)
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveRow?(tableView, sourceIndexPath, destinationIndexPath)
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension TableDataDelegate: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        prefetchRows?(tableView, indexPaths)
    }
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        cancelPrefetchingForRows?(tableView, indexPaths)
    }
}
