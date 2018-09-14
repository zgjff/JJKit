//
// eg:
// override func viewDidLoad() {
//     super.viewDidLoad()
//     tableView.frame = view.bounds
//     view.addSubview(tableView)
//     tableView.jj.dataSourceDelegate?
//         .numberOfSections(viewModel.numberOfSections) // 这里可以直接调用viewModel的方法名作为参数
//         .numberOfRowsInSection(viewModel.numberOfRowsInSection)
//         .heightForRow(viewModel.heightForRow)
//         .cellForRow({ [unowned self] tableView, indexPath -> UITableViewCell in
//             这里一定要注意循环引用,切记不可跟viewModel一样调用当前类的方法名做参数,否则会循环引用,切记！切记！切记！
//             return self.createCell(indexPath: indexPath)
//         })
//         .didSelectRow({ tableView, indexPath in
//             print(indexPath)
//         })
//         .prefetchRows({ tableView, ids in
//             print(ids)
//         })
//        .bind() // 最后一定写调用此方法
// }
// func createCell(indexPath: IndexPath) -> UITableViewCell {
//     let cell = tableView.dequeueReusableCell(withIdentifier: cellid) ?? UITableViewCell(style: .value1, reuseIdentifier: cellid)
//     cell.textLabel?.text = "\(indexPath.section)---\(indexPath.row)"
//     return cell
// }
//
// class ThirdViewModel {
//     func numberOfSections() -> Int {
//         return 3
//     }
//    func numberOfRowsInSection(_ section: Int) -> Int {
//          switch section {
//         case 0: return 13
//         case 1: return 15
//         case 2: return 20
//         default: return 0
//         }
//     }
//     func heightForRow(at indexPath: IndexPath) -> CGFloat {
//         switch indexPath.section {
//         case 0: return 44
//         case 1: return 88
//         case 2: return 100
//         default: return 0
//         }
//     }
// }
import UIKit

private var tableViewKey: Void?
extension JJ where Original: UITableView {
    public weak var dataSourceDelegate: TableViewDelegateManager? {
        get {
            return StoreValueManager.get(from: original, key: &tableViewKey, initialiser: {
                return TableViewDelegateManager(tableView: original)
            })
        }
        set {
            StoreValueManager.set(for: original, key: &tableViewKey, value: newValue)
        }
    }
}

public final class TableViewDelegateManager {
    deinit {
        print("TableViewDelegateManager  deinit")
    }
    
    private unowned let tableView: UITableView
    private var delegate: TableViewDataDelegate?
    init?(tableView: UITableView, delegate: TableViewDataDelegate = TableViewDataDelegate()) {
        guard tableView.delegate == nil, tableView.dataSource == nil else {
            return nil
        }
        self.tableView = tableView
        self.delegate = delegate
        delegate.delegateManager = self
    }
    
    public func bind() {
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.delegate = delegate
        tableView.dataSource = delegate
        guard #available(iOS 10.0, *) else {
            return
        }
        let prefetch = delegate?.responds(to: #selector(delegate?.tableView(_:prefetchRowsAt:))) ?? false
        let cancelPrefetching = delegate?.responds(to: #selector(delegate?.tableView(_:cancelPrefetchingForRowsAt:))) ?? false
        if prefetch || cancelPrefetching {
            tableView.prefetchDataSource = nil
            tableView.prefetchDataSource = delegate
        }
    }
}

// MARK: - UITableViewDelegate
extension TableViewDelegateManager {
    @discardableResult
    public func willDisplayCell(_ block: @escaping (_ cell: UITableViewCell, _ indexPath: IndexPath) -> ()) -> Self {
        delegate?.willDisplayCell = block
        return self
    }
    @discardableResult
    public func willDisplayHeaderView(_ block: @escaping (_ view: UIView, _ section: Int) -> ()) -> Self{
        delegate?.willDisplayHeaderView = block
        return self
    }
    @discardableResult
    public func willDisplayFooterView(_ block: @escaping (_ view: UIView, _ section: Int) -> ()) -> Self{
        delegate?.willDisplayFooterView = block
        return self
    }
    @discardableResult
    public func didEndDisplayingCell(_ block: @escaping (_ cell: UITableViewCell, _ indexPath: IndexPath) -> ()) -> Self {
        delegate?.didEndDisplayingCell = block
        return self
    }
    @discardableResult
    public func heightForRow(_ block: @escaping (_ indexPath: IndexPath) -> CGFloat) -> Self {
        delegate?.heightForRow = block
        return self
    }
    @discardableResult
    public func heightForHeader(_ block: @escaping (_ section: Int) -> CGFloat) -> Self {
        delegate?.heightForHeader = block
        return self
    }
    @discardableResult
    public func heightForFooter(_ block: @escaping (_ section: Int) -> CGFloat) -> Self {
        delegate?.heightForFooter = block
        return self
    }
    @discardableResult
    public func estimatedHeightForRow(_ block: @escaping (_ indexPath: IndexPath) -> CGFloat) -> Self {
        delegate?.estimatedHeightForRow = block
        return self
    }
    @discardableResult
    public func estimatedHeightForHeader(_ block: @escaping (_ section: Int) -> CGFloat) -> Self {
        delegate?.estimatedHeightForHeader = block
        return self
    }
    @discardableResult
    public func estimatedHeightForFooter(_ block: @escaping (_ section: Int) -> CGFloat) -> Self {
        delegate?.estimatedHeightForFooter = block
        return self
    }
    @discardableResult
    public func viewForHeader(_ block: @escaping (_ section: Int) -> UIView?) -> Self {
        delegate?.viewForHeader = block
        return self
    }
    @discardableResult
    public func viewForFooter(_ block: @escaping (_ section: Int) -> UIView?) -> Self {
        delegate?.viewForFooter = block
        return self
    }
    @discardableResult
    public func willSelectRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> IndexPath?) -> Self {
        delegate?.willSelectRow = block
        return self
    }
    @discardableResult
    public func didSelectRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> ()) -> Self {
        delegate?.didSelectRow = block
        return self
    }
    @discardableResult
    public func willDeselectRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> IndexPath?) -> Self {
        delegate?.willDeselectRow = block
        return self
    }
    @discardableResult
    public func didDeselectRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> ()) -> Self {
        delegate?.didDeselectRow = block
        return self
    }
    @discardableResult
    public func editingStyleForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCellEditingStyle) -> Self {
        delegate?.editingStyleForRow = block
        return self
    }
    @discardableResult
    public func editActionsForRow(_ block: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> [UITableViewRowAction]) -> Self {
        delegate?.editActionsForRow = block
        return self
    }
    @discardableResult
    public func accessoryButtonTapped(_ block: @escaping (_ indexPath: IndexPath) -> ()) -> Self {
        delegate?.accessoryButtonTapped = block
        return self
    }
    @discardableResult
    public func titleForDeleteConfirmationButton(_ block: @escaping (_ indexPath: IndexPath) -> String?) -> Self {
        delegate?.titleForDeleteConfirmationButton = block
        return self
    }
    @available(iOS 11.0, *)
    @discardableResult
    public func leadingSwipeActionsConfiguration(_ block: @escaping (_ indexPath: IndexPath) -> UISwipeActionsConfiguration?) -> Self {
        delegate?._leadingSwipeActionsConfiguration = block
        return self
    }
    @available(iOS 11.0, *)
    @discardableResult
    public func trailingSwipeActionsConfiguration(_ block: @escaping (_ indexPath: IndexPath) -> UISwipeActionsConfiguration?) -> Self {
        delegate?._trailingSwipeActionsConfiguration = block
        return self
    }
}
// MARK: - UITableViewDataSource
extension TableViewDelegateManager {
    @discardableResult
    public func numberOfSections(_ block: @escaping () -> Int) -> Self {
        delegate?.numberOfSections = block
        return self
    }
    @discardableResult
    public func numberOfRowsInSection(_ block: @escaping (_ section: Int) -> Int) -> Self {
        delegate?.numberOfRows = block
        return self
    }
    @discardableResult
    public func cellForRow(_ block: @escaping (_ tableView: UITableView,_ indexPath: IndexPath) -> UITableViewCell) -> Self {
        delegate?.cellForRow = block
        return self
    }
    @discardableResult
    public func titleForHeader(_ block: @escaping (_ section: Int) -> String?) -> Self {
        delegate?.titleForHeader = block
        return self
    }
    @discardableResult
    public func titleForFooter(_ block: @escaping (_ section: Int) -> String?) -> Self {
        delegate?.titleForFooter = block
        return self
    }
    @discardableResult
    public func canEditRow(_ block: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        delegate?.canEditRow = block
        return self
    }
    @discardableResult
    public func commit(_ block: @escaping (_ editingStyle: UITableViewCellEditingStyle, _ indexPath: IndexPath) -> ()) -> Self {
        delegate?.commit = block
        return self
    }
    @discardableResult
    public func canMove(_ block: @escaping (_ indexPath: IndexPath) -> Bool) -> Self {
        delegate?.canMove = block
        return self
    }
    @discardableResult
    public func moveRow(_ block: @escaping (_ source: IndexPath, _ destination: IndexPath) -> ()) -> Self {
        delegate?.moveRow = block
        return self
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension TableViewDelegateManager {
    @available(iOS 10.0, *)
    @discardableResult
    public func prefetchRows(_ block: @escaping (_ tableView: UITableView, _ indexPaths: [IndexPath]) -> ()) -> Self {
        delegate?.prefetchRows = block
        return self
    }
    @available(iOS 10.0, *)
    @discardableResult
    public func cancelPrefetchingForRows(_ block: @escaping (_ tableView: UITableView, _ indexPaths: [IndexPath]) -> ()) -> Self {
        delegate?.cancelPrefetchingForRows = block
        return self
    }
}

final class TableViewDataDelegate: NSObject {
    // UITableViewDataSource
    var numberOfSections: (() -> Int)?
    var numberOfRows: ((_ section: Int) -> Int)?
    var cellForRow: ((_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell)?
    var titleForHeader: ((_ section: Int) -> String?)?
    var titleForFooter: ((_ section: Int) -> String?)?
    var canEditRow: ((_ indexPath: IndexPath) -> Bool)?
    var commit: ((_ editingStyle: UITableViewCellEditingStyle, _ indexPath: IndexPath) -> ())?
    var canMove: ((_ indexPath: IndexPath) -> Bool)?
    var moveRow: ((_ source: IndexPath, _ destination: IndexPath) -> ())?
    
    // UITableViewDelegate
    var willDisplayCell: ((_ cell: UITableViewCell, _ indexPath: IndexPath) -> ())?
    var willDisplayHeaderView: ((_ view: UIView, _ section: Int) -> ())?
    var willDisplayFooterView: ((_ view: UIView, _ section: Int) -> ())?
    var didEndDisplayingCell: ((_ cell: UITableViewCell, _ indexPath: IndexPath) -> ())?
    var heightForRow: ((_ indexPath: IndexPath) -> CGFloat)?
    var heightForHeader: ((_ section: Int) -> CGFloat)?
    var heightForFooter: ((_ section: Int) -> CGFloat)?
    var estimatedHeightForRow: ((_ indexPath: IndexPath) -> CGFloat)?
    var estimatedHeightForHeader: ((_ section: Int) -> CGFloat)?
    var estimatedHeightForFooter: ((_ section: Int) -> CGFloat)?
    var viewForHeader: ((_ section: Int) -> UIView?)?
    var viewForFooter: ((_ section: Int) -> UIView?)?
    var willSelectRow: ((_ tableView: UITableView, _ indexPath: IndexPath) -> IndexPath?)?
    var didSelectRow: ((_ tableView: UITableView, _ indexPath: IndexPath) -> ())?
    var willDeselectRow: ((_ tableView: UITableView, _ indexPath: IndexPath) -> IndexPath?)?
    var didDeselectRow: ((_ tableView: UITableView, _ indexPath: IndexPath) -> ())?
    var editingStyleForRow: ((_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCellEditingStyle)?
    var editActionsForRow: ((_ tableView: UITableView, _ indexPath: IndexPath) -> [UITableViewRowAction])?
    var accessoryButtonTapped: ((_ indexPath: IndexPath) -> ())?
    // UITableViewDataSourcePrefetching
    var prefetchRows: ((_ tableView: UITableView, _ indexPaths: [IndexPath]) -> ())?
    var cancelPrefetchingForRows: ((_ tableView: UITableView, _ indexPaths: [IndexPath]) -> ())?
    
    fileprivate var _leadingSwipeActionsConfiguration: Any?
    @available(iOS 11, *)
    var leadingSwipeActionsConfiguration: ((_ indexPath: IndexPath) -> UISwipeActionsConfiguration?)? {
        get {
            return _leadingSwipeActionsConfiguration as? (_ indexPath: IndexPath) -> UISwipeActionsConfiguration?
        }
        set {
            _leadingSwipeActionsConfiguration = newValue
        }
    }
    fileprivate var _trailingSwipeActionsConfiguration: Any?
    @available(iOS 11, *)
    var trailingSwipeActionsConfiguration: ((_ indexPath: IndexPath) -> UISwipeActionsConfiguration?)? {
        get {
            return _trailingSwipeActionsConfiguration as? (_ indexPath: IndexPath) -> UISwipeActionsConfiguration?
        }
        set {
            _trailingSwipeActionsConfiguration = newValue
        }
    }
    var titleForDeleteConfirmationButton: ((_ indexPath: IndexPath) -> String?)?
    
    
    weak var delegateManager: TableViewDelegateManager?
    
    public override init() {
        super.init()
    }
}

extension TableViewDataDelegate {
    open override func responds(to aSelector: Selector!) -> Bool {
        if #available(iOS 11, *) {
            switch aSelector {
            case #selector(TableViewDataDelegate.tableView(_:leadingSwipeActionsConfigurationForRowAt:)):
                return leadingSwipeActionsConfiguration != nil
            case #selector(TableViewDataDelegate.tableView(_:trailingSwipeActionsConfigurationForRowAt:)):
                return trailingSwipeActionsConfiguration != nil
            default: break
            }
        }
        switch aSelector {
        // UITableViewDataSource
        case #selector(TableViewDataDelegate.numberOfSections(in:)):
            return numberOfSections != nil
        case #selector(TableViewDataDelegate.tableView(_:numberOfRowsInSection:)):
            return numberOfRows != nil
        case #selector(TableViewDataDelegate.tableView(_:cellForRowAt:)):
            return cellForRow != nil
        case #selector(TableViewDataDelegate.tableView(_:titleForHeaderInSection:)):
            return titleForHeader != nil
        case #selector(TableViewDataDelegate.tableView(_:titleForFooterInSection:)):
            return titleForFooter != nil
        case #selector(TableViewDataDelegate.tableView(_:canEditRowAt:)):
            return canEditRow != nil
        case #selector(TableViewDataDelegate.tableView(_:commit:forRowAt:)):
            return commit != nil
        case #selector(TableViewDataDelegate.tableView(_:canMoveRowAt:)):
            return canMove != nil
        case #selector(TableViewDataDelegate.tableView(_:moveRowAt:to:)):
            return moveRow != nil
        // UITableViewDelegate
        case #selector(TableViewDataDelegate.tableView(_:willDisplay:forRowAt:)):
            return willDisplayCell != nil
        case #selector(TableViewDataDelegate.tableView(_:willDisplayHeaderView:forSection:)):
            return willDisplayHeaderView != nil
        case #selector(TableViewDataDelegate.tableView(_:willDisplayFooterView:forSection:)):
            return willDisplayFooterView != nil
        case #selector(TableViewDataDelegate.tableView(_:didEndDisplaying:forRowAt:)):
            return didEndDisplayingCell != nil
        case #selector(TableViewDataDelegate.tableView(_:heightForRowAt:)):
            return heightForRow != nil
        case #selector(TableViewDataDelegate.tableView(_:heightForHeaderInSection:)):
            return heightForHeader != nil
        case #selector(TableViewDataDelegate.tableView(_:heightForFooterInSection:)):
            return heightForFooter != nil
        case #selector(TableViewDataDelegate.tableView(_:estimatedHeightForRowAt:)):
            return estimatedHeightForRow != nil
        case #selector(TableViewDataDelegate.tableView(_:heightForHeaderInSection:)):
            return estimatedHeightForHeader != nil
        case #selector(TableViewDataDelegate.tableView(_:heightForFooterInSection:)):
            return estimatedHeightForFooter != nil
        case #selector(TableViewDataDelegate.tableView(_:viewForHeaderInSection:)):
            return viewForHeader != nil
        case #selector(TableViewDataDelegate.tableView(_:viewForFooterInSection:)):
            return viewForFooter != nil
        case #selector(TableViewDataDelegate.tableView(_:willSelectRowAt:)):
            return willSelectRow != nil
        case #selector(TableViewDataDelegate.tableView(_:didSelectRowAt:)):
            return didSelectRow != nil
        case #selector(TableViewDataDelegate.tableView(_:willDeselectRowAt:)):
            return willDeselectRow != nil
        case #selector(TableViewDataDelegate.tableView(_:didSelectRowAt:)):
            return didDeselectRow != nil
        case #selector(TableViewDataDelegate.tableView(_:editingStyleForRowAt:)):
            return editingStyleForRow != nil
        case #selector(TableViewDataDelegate.tableView(_:editActionsForRowAt:)):
            return editActionsForRow != nil
        case #selector(TableViewDataDelegate.tableView(_:accessoryButtonTappedForRowWith:)):
            return accessoryButtonTapped != nil
        case #selector(TableViewDataDelegate.tableView(_:titleForDeleteConfirmationButtonForRowAt:)):
            return titleForDeleteConfirmationButton != nil
        //UITableViewDataSourcePrefetching
        case #selector(TableViewDataDelegate.tableView(_:prefetchRowsAt:)):
            return prefetchRows != nil
        case #selector(TableViewDataDelegate.tableView(_:cancelPrefetchingForRowsAt:)):
            return cancelPrefetchingForRows != nil
        default:
            return super.responds(to: aSelector)
        }
    }
}

extension TableViewDataDelegate: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplayCell?(cell, indexPath)
    }
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        willDisplayHeaderView?(view, section)
    }
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        willDisplayFooterView?(view, section)
    }
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        didEndDisplayingCell?(cell, indexPath)
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow?(indexPath) ?? 44
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader?(section) ?? 0.01
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooter?(section) ?? 0.01
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedHeightForRow?(indexPath) ?? 44
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return estimatedHeightForHeader?(section) ?? 0.01
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return estimatedHeightForFooter?(section) ?? 0.01
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeader?(section)
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForFooter?(section)
    }
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return willSelectRow?(tableView, indexPath)
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow?(tableView, indexPath)
    }
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return willDeselectRow?(tableView, indexPath)
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselectRow?(tableView, indexPath)
    }
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return editingStyleForRow?(tableView, indexPath) ?? .delete
    }
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return editActionsForRow?(tableView, indexPath)
    }
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        accessoryButtonTapped?(indexPath)
    }
    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return titleForDeleteConfirmationButton?(indexPath) ?? "Delete"
    }
    
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return leadingSwipeActionsConfiguration?(indexPath)
    }
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return trailingSwipeActionsConfiguration?(indexPath)
    }
}


extension TableViewDataDelegate: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections?() ?? 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows?(section) ?? 0
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRow?(tableView, indexPath) ?? UITableViewCell()
    }
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeader?(section)
    }
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return titleForFooter?(section)
    }
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return canEditRow?(indexPath) ?? true
    }
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        commit?(editingStyle, indexPath)
    }
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return canMove?(indexPath) ?? false
    }
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveRow?(sourceIndexPath, destinationIndexPath)
    }
}

extension TableViewDataDelegate: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        prefetchRows?(tableView, indexPaths)
    }
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        cancelPrefetchingForRows?(tableView, indexPaths)
    }
}

