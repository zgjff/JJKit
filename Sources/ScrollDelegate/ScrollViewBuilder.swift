import UIKit

public class ScrollViewBuilder {
    internal var manager: ScrollDelegateManager?
    internal required init(manager: ScrollDelegateManager) {
        self.manager = manager
    }
    internal func build(for scrollView: UIScrollView) {
        scrollView.delegate = nil
        scrollView.delegate = manager
    }
}

public extension ScrollViewBuilder {
    func didScroll(_ block: @escaping (_ scrollView: UIScrollView) -> ()) {
        manager?.didScroll = block
    }
    func didZoom(_ block: @escaping (_ scrollView: UIScrollView) -> ()) {
        manager?.didZoom = block
    }
    func willBeginDragging(_ block: @escaping (_ scrollView: UIScrollView) -> ()) {
        manager?.willBeginDragging = block
    }
    func willEndDragging(_ block: @escaping (_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> ()) {
        manager?.willEndDragging = block
    }
    func didEndDragging(_ block: @escaping (_ scrollView: UIScrollView, _ decelerate: Bool) -> ()) {
        manager?.didEndDragging = block
    }
    func willBeginDecelerating(_ block: @escaping (_ scrollView: UIScrollView) -> ()) {
        manager?.willBeginDecelerating = block
    }
    func didEndDecelerating(_ block: @escaping (_ scrollView: UIScrollView) -> ()) {
        manager?.didEndDecelerating = block
    }
    func didEndScrollingAnimation(_ block: @escaping (_ scrollView: UIScrollView) -> ()) {
        manager?.didEndScrollingAnimation = block
    }
    func viewForZooming(_ block: @escaping (_ scrollView: UIScrollView) -> UIView?) {
        manager?.viewForZooming = block
    }
    func willBeginZooming(_ block: @escaping (_ scrollView: UIScrollView, _ view: UIView?) -> ()) {
        manager?.willBeginZooming = block
    }
    func didEndZooming(_ block: @escaping (_ scrollView: UIScrollView, _ view: UIView?, _ scale: CGFloat) -> ()) {
        manager?.didEndZooming = block
    }
    func shouldScrollToTop(_ block: @escaping (_ scrollView: UIScrollView) -> Bool) {
        manager?.shouldScrollToTop = block
    }
    func didScrollToTop(_ block: @escaping (_ scrollView: UIScrollView) -> ()) {
        manager?.didScrollToTop = block
    }
    @available(iOS 11, *)
    func didChangeAdjustedContentInset(_ block: @escaping (_ scrollView: UIScrollView) -> ()) {
        manager?.didChangeAdjustedContentInset = block
    }
}
