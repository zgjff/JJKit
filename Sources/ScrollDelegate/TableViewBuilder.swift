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
    @discardableResult
    func willDisplayCell(_ block: @escaping (_ tableView: UITableView, _ cell: UITableViewCell, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.willDisplayCell = block
        return self
    }
    @discardableResult
    func willDisplayHeaderView(_ block: @escaping (_ tableView: UITableView, _ headerView: UIView, _ section: Int) -> ()) -> Self {
        _manager.willDisplayHeaderView = block
        return self
    }
    @discardableResult
    func willDisplayFooterView(_ block: @escaping (_ tableView: UITableView, _ footerView: UIView, _ section: Int) -> ()) -> Self {
        _manager.willDisplayFooterView = block
        return self
    }
    @discardableResult
    func didEndDisplayingCell(_ block: @escaping (_ tableView: UITableView, _ cell: UITableViewCell, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.didEndDisplayingCell = block
        return self
    }
    @discardableResult
    func didEndDisplayingHeaderView(_ block: @escaping (_ tableView: UITableView, _ headerView: UIView, _ section: Int) -> ()) -> Self {
        _manager.didEndDisplayingHeaderView = block
        return self
    }
    @discardableResult
    func didEndDisplayingFooterView(_ block: @escaping (_ tableView: UITableView, _ footerView: UIView, _ section: Int) -> ()) -> Self {
        _manager.didEndDisplayingFooterView = block
        return self
    }
    @discardableResult
    func heightForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat) -> Self {
        _manager.heightForRow = block
        return self
    }
    @discardableResult
    func heightForHeader(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> CGFloat) -> Self {
        _manager.heightForHeader = block
        return self
    }
    @discardableResult
    func heightForFooter(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> CGFloat) -> Self {
        _manager.heightForFooter = block
        return self
    }
    @discardableResult
    func estimatedHeightForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat) -> Self {
        _manager.estimatedHeightForRow = block
        return self
    }
    @discardableResult
    func estimatedHeightForHeader(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> CGFloat) -> Self {
        _manager.estimatedHeightForHeader = block
        return self
    }
    @discardableResult
    func estimatedHeightForFooter(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> CGFloat) -> Self {
        _manager.estimatedHeightForFooter = block
        return self
    }
    @discardableResult
    func viewForHeader(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> UIView?) -> Self {
        _manager.viewForHeader = block
        return self
    }
    @discardableResult
    func viewForFooter(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> UIView?) -> Self {
        _manager.viewForFooter = block
        return self
    }
    @discardableResult
    func accessoryButtonTappedForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.accessoryButtonTappedForRow = block
        return self
    }
    @discardableResult
    func shouldHighlightRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> Bool) -> Self {
        _manager.shouldHighlightRow = block
        return self
    }
    @discardableResult
    func didHighlightRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.didHighlightRow = block
        return self
    }
    @discardableResult
    func didUnhighlightRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.didUnhighlightRow = block
        return self
    }
    @discardableResult
    func willSelectRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> IndexPath?) -> Self {
        _manager.willSelectRow = block
        return self
    }
    @discardableResult
    func willDeselectRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> IndexPath?) -> Self {
        _manager.willDeselectRow = block
        return self
    }
    @discardableResult
    func didSelectRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.didSelectRow = block
        return self
    }
    @discardableResult
    func didDeselectRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.didDeselectRow = block
        return self
    }
    @discardableResult
    func editingStyleForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell.EditingStyle) -> Self {
        _manager.editingStyleForRow = block
        return self
    }
    @discardableResult
    func titleForDeleteConfirmationButtonForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> String?) -> Self {
        _manager.titleForDeleteConfirmationButtonForRow = block
        return self
    }
    @discardableResult
    func editActionsForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> [UITableViewRowAction]?) -> Self {
        _manager.editActionsForRow = block
        return self
    }
    @available(iOS 11, *)
    @discardableResult
    func leadingSwipeActionsConfigurationForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> UISwipeActionsConfiguration?) -> Self {
        _manager.leadingSwipeActionsConfigurationForRow = block
        return self
    }
    @available(iOS 11, *)
    @discardableResult
    func trailingSwipeActionsConfigurationForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> UISwipeActionsConfiguration?) -> Self {
        _manager.trailingSwipeActionsConfigurationForRow = block
        return self
    }
    @discardableResult
    func shouldIndentWhileEditingRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> Bool) -> Self {
        _manager.shouldIndentWhileEditingRow = block
        return self
    }
    @discardableResult
    func willBeginEditingRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.willBeginEditingRow = block
        return self
    }
    @discardableResult
    func didEndEditingRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath?) -> ()) -> Self {
        _manager.didEndEditingRow = block
        return self
    }
    @discardableResult
    func indexPathForMoveFromRow(_ block: @escaping (_ tableView: UITableView, _ sourceIndexPath: IndexPath, _ proposedDestinationIndexPath: IndexPath) -> IndexPath) -> Self {
        _manager.indexPathForMoveFromRow = block
        return self
    }
    @discardableResult
    func indentationLevelForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath?) -> Int) -> Self {
        _manager.indentationLevelForRow = block
        return self
    }
    @discardableResult
    func shouldShowMenuForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath?) -> Bool) -> Self {
        _manager.shouldShowMenuForRow = block
        return self
    }
    @discardableResult
    func canPerformAction(_ block: @escaping (_ tableView: UITableView, _ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> Bool) -> Self {
        _manager.canPerformAction = block
        return self
    }
    @discardableResult
    func performAction(_ block: @escaping (_ tableView: UITableView, _ action: Selector, _ indexPath: IndexPath, _ sender: Any?) -> ()) -> Self {
        _manager.performAction = block
        return self
    }
    @discardableResult
    func canFocusRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> Bool) -> Self {
        _manager.canFocusRow = block
        return self
    }
    @discardableResult
    func shouldUpdateFocus(_ block: @escaping (_ tableView: UITableView, _ context: UITableViewFocusUpdateContext) -> Bool) -> Self {
        _manager.shouldUpdateFocus = block
        return self
    }
    @discardableResult
    func didUpdateFocus(_ block: @escaping (_ tableView: UITableView, _ context: UITableViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> ()) -> Self {
        _manager.didUpdateFocus = block
        return self
    }
    @discardableResult
    func indexPathForPreferredFocusedView(_ block: @escaping (_ tableView: UITableView) -> IndexPath?) -> Self {
        _manager.indexPathForPreferredFocusedView = block
        return self
    }
    @available(iOS 11, *)
    @discardableResult
    func shouldSpringLoadRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath, _ context: UISpringLoadedInteractionContext) -> Bool) -> Self {
        _manager.shouldSpringLoadRow = block
        return self
    }
}

// MARK: - UITableViewDataSource
public extension TableViewBuilder {
    @discardableResult
    func numberOfRows(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> Int) -> Self {
        _manager.numberOfRows = block
        return self
    }
    @discardableResult
    func cellForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell) -> Self {
        _manager.cellForRow = block
        return self
    }
    @discardableResult
    func numberOfSections(_ block: @escaping (_ tableView: UITableView) -> Int) -> Self {
        _manager.numberOfSections = block
        return self
    }
    @discardableResult
    func titleForHeader(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> String) -> Self {
        _manager.titleForHeader = block
        return self
    }
    @discardableResult
    func titleForFooter(_ block: @escaping (_ tableView: UITableView, _ section: Int) -> String) -> Self {
        _manager.titleForFooter = block
        return self
    }
    @discardableResult
    func canEditRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> Bool) -> Self {
        _manager.canEditRow = block
        return self
    }
    @discardableResult
    func canMoveRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> Bool) -> Self {
        _manager.canMoveRow = block
        return self
    }
    @discardableResult
    func sectionForSectionIndexTitle(_ block: @escaping (_ tableView: UITableView, _ title: String, _ index: Int) -> Int) -> Self {
        _manager.sectionForSectionIndexTitle = block
        return self
    }
    @discardableResult
    func commit(_ block: @escaping (_ tableView: UITableView, _ editingStyle: UITableViewCell.EditingStyle, _ indexPath: IndexPath) -> ()) -> Self {
        _manager.commit = block
        return self
    }
    @discardableResult
    func moveRow(_ block: @escaping (_ tableView: UITableView, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> ()) -> Self {
        _manager.moveRow = block
        return self
    }
}

// MARK: - UITableViewDataSourcePrefetching
public extension TableViewBuilder {
    @available(iOS 10.0, *)
    @discardableResult
    func prefetchRows(_ block: @escaping (_ tableView: UITableView, _ indexPaths: [IndexPath]) -> ()) -> Self {
        isConfigDataSourcePrefetching = true
        _manager.prefetchRows = block
        return self
    }
    @available(iOS 10.0, *)
    @discardableResult
    func cancelPrefetchingForRows(_ block: @escaping (_ tableView: UITableView, _ indexPaths: [IndexPath]) -> ()) -> Self {
        isConfigDataSourcePrefetching = true
        _manager.cancelPrefetchingForRows = block
        return self
    }
}
