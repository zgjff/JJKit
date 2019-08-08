import UIKit

public class TableViewBuilder: ScrollViewBuilder {
    private unowned var _manager: TableDataDelegate! {
        return manager as? TableDataDelegate
    }
    /// 是否设定了prefetchDataSource代理,默认是false
    private var isConfigDataSourcePrefetching = false
    internal func build(for tableView: UITableView) {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.delegate = _manager
        tableView.dataSource = _manager
        if #available(iOS 10.0, *) {
            if isConfigDataSourcePrefetching {
                tableView.prefetchDataSource = _manager
            }
        }
    }
}

// MARK: - UITableViewDelegate
public extension TableViewBuilder {
    func willDisplayCell(_ block: @escaping (_ tableView: UITableView, _ cell: UITableViewCell, _ indexPath: IndexPath) -> ()) {
        _manager.willDisplayCell = block
    }
    func willDisplayHeaderView(_ block: @escaping (_ tableView: UITableView, _ headerView: UIView, _ section: Int) -> ()) {
        _manager.willDisplayHeaderView = block
    }
    func willDisplayFooterView(_ block: @escaping (_ tableView: UITableView, _ footerView: UIView, _ section: Int) -> ()) {
        _manager.willDisplayFooterView = block
    }
    func didEndDisplayingCell(_ block: @escaping (_ tableView: UITableView, _ cell: UITableViewCell, _ indexPath: IndexPath) -> ()) {
        _manager.didEndDisplayingCell = block
    }
    func didEndDisplayingHeaderView(_ block: @escaping (_ tableView: UITableView, _ headerView: UIView, _ section: Int) -> ()) {
        _manager.didEndDisplayingHeaderView = block
    }
    func didEndDisplayingFooterView(_ block: @escaping (_ tableView: UITableView, _ footerView: UIView, _ section: Int) -> ()) {
        _manager.didEndDisplayingFooterView = block
    }
    func heightForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat) {
        _manager.heightForRow = block
    }
    func heightForHeader(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> CGFloat) {
        _manager.heightForHeader = block
    }
    func heightForFooter(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> CGFloat) {
        _manager.heightForFooter = block
    }
    func estimatedHeightForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat) {
        _manager.estimatedHeightForRow = block
    }
    func estimatedHeightForHeader(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> CGFloat) {
        _manager.estimatedHeightForHeader = block
    }
    func estimatedHeightForFooter(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> CGFloat) {
        _manager.estimatedHeightForFooter = block
    }
    func viewForHeader(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> UIView?) {
        _manager.viewForHeader = block
    }
    func viewForFooter(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> UIView?) {
        _manager.viewForFooter = block
    }
    func accessoryButtonTappedForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> ()) {
        _manager.accessoryButtonTappedForRow = block
    }
    func shouldHighlightRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> Bool) {
        _manager.shouldHighlightRow = block
    }
    func didHighlightRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> ()) {
        _manager.didHighlightRow = block
    }
    func didUnhighlightRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> ()) {
        _manager.didUnhighlightRow = block
    }
    func willSelectRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> IndexPath?) {
        _manager.willSelectRow = block
    }
    func willDeselectRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> IndexPath?) {
        _manager.willDeselectRow = block
    }
    func didSelectRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> ()) {
        _manager.didSelectRow = block
    }
    func didDeselectRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> ()) {
        _manager.didDeselectRow = block
    }
    func editingStyleForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell.EditingStyle) {
        _manager.editingStyleForRow = block
    }
    func titleForDeleteConfirmationButtonForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> String?) {
        _manager.titleForDeleteConfirmationButtonForRow = block
    }
    func editActionsForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> [UITableViewRowAction]?) {
        _manager.editActionsForRow = block
    }
    @available(iOS 11, *)
    func leadingSwipeActionsConfigurationForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> UISwipeActionsConfiguration?) {
        _manager.leadingSwipeActionsConfigurationForRow = block
    }
    @available(iOS 11, *)
    func trailingSwipeActionsConfigurationForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> UISwipeActionsConfiguration?) {
        _manager.trailingSwipeActionsConfigurationForRow = block
    }
    func shouldIndentWhileEditingRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> Bool) {
        _manager.shouldIndentWhileEditingRow = block
    }
    func willBeginEditingRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> ()) {
        _manager.willBeginEditingRow = block
    }
    func didEndEditingRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath?) -> ()) {
        _manager.didEndEditingRow = block
    }
    func indexPathForMoveFromRow(_ block: @escaping (_ tableView: UITableView, _ sourceIndexPath: IndexPath, _ proposedDestinationIndexPath: IndexPath) -> IndexPath) {
        _manager.indexPathForMoveFromRow = block
    }
    func indentationLevelForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath?) -> Int) {
        _manager.indentationLevelForRow = block
    }
    func shouldShowMenuForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath?) -> Bool) {
        _manager.shouldShowMenuForRow = block
    }
    func canPerformAction(_ block: @escaping (_ tableView: UITableView, _ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> Bool) {
        _manager.canPerformAction = block
    }
    func performAction(_ block: @escaping (_ tableView: UITableView, _ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> ()) {
        _manager.performAction = block
    }
    func canFocusRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> Bool) {
        _manager.canFocusRow = block
    }
    func shouldUpdateFocus(_ block: @escaping (_ tableView: UITableView, _ context: UITableViewFocusUpdateContext) -> Bool) {
        _manager.shouldUpdateFocus = block
    }
    func didUpdateFocus(_ block: @escaping (_ tableView: UITableView, _ context: UITableViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> ()) {
        _manager.didUpdateFocus = block
    }
    func indexPathForPreferredFocusedView(_ block: @escaping (_ tableView: UITableView) -> IndexPath?) {
        _manager.indexPathForPreferredFocusedView = block
    }
    @available(iOS 11, *)
    func shouldSpringLoadRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath, _ context: UISpringLoadedInteractionContext) -> Bool) {
        _manager.shouldSpringLoadRow = block
    }
}

// MARK: - UITableViewDataSource
public extension TableViewBuilder {
    func numberOfRows(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> Int) {
        _manager.numberOfRows = block
    }
    func cellForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell) {
        _manager.cellForRow = block
    }
    func numberOfSections(_ block: @escaping (_ tableView: UITableView) -> Int) {
        _manager.numberOfSections = block
    }
    func titleForHeader(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> String) {
        _manager.titleForHeader = block
    }
    func titleForFooter(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> String) {
        _manager.titleForFooter = block
    }
    func canEditRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> Bool) {
        _manager.canEditRow = block
    }
    func canMoveRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> Bool) {
        _manager.canMoveRow = block
    }
    func sectionForSectionIndexTitle(_ block: @escaping (_ tableView: UITableView, _ title: String, _ index: Int) -> Int) {
        _manager.sectionForSectionIndexTitle = block
    }
    func commit(_ block: @escaping (_ tableView: UITableView, _ editingStyle: UITableViewCell.EditingStyle, _ indexPath: IndexPath) -> ()) {
        _manager.commit = block
    }
    func moveRow(_ block: @escaping (_ tableView: UITableView, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> ()) {
        _manager.moveRow = block
    }
}

// MARK: - UITableViewDataSourcePrefetching
public extension TableViewBuilder {
    @available(iOS 10.0, *)
    func prefetchRows(_ block: @escaping (_ tableView: UITableView, _ indexPaths: [IndexPath]) -> ()) {
        isConfigDataSourcePrefetching = true
        _manager.prefetchRows = block
    }
    @available(iOS 10.0, *)
    func cancelPrefetchingForRows(_ block: @escaping (_ tableView: UITableView, _ indexPaths: [IndexPath]) -> ()) {
        isConfigDataSourcePrefetching = true
        _manager.cancelPrefetchingForRows = block
    }
}
