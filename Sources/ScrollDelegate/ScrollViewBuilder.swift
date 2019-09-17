import UIKit

public class ScrollViewBuilder {
    internal var manager: ScrollViewBuilder.Manager?
    internal required init(manager: ScrollViewBuilder.Manager) {
        self.manager = manager
    }
    internal func build(for scrollView: UIScrollView) {
        scrollView.delegate = nil
        scrollView.delegate = manager
    }
}

public extension ScrollViewBuilder {
    @discardableResult
    func didScroll(_ block: @escaping (_ scrollView: UIScrollView) -> ()) -> Self {
        manager?.didScroll = block
        return self
    }
    @discardableResult
    func didZoom(_ block: @escaping (_ scrollView: UIScrollView) -> ()) -> Self {
        manager?.didZoom = block
        return self
    }
    @discardableResult
    func willBeginDragging(_ block: @escaping (_ scrollView: UIScrollView) -> ()) -> Self {
        manager?.willBeginDragging = block
        return self
    }
    @discardableResult
    func willEndDragging(_ block: @escaping (_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> ()) -> Self {
        manager?.willEndDragging = block
        return self
    }
    @discardableResult
    func didEndDragging(_ block: @escaping (_ scrollView: UIScrollView, _ decelerate: Bool) -> ()) -> Self {
        manager?.didEndDragging = block
        return self
    }
    @discardableResult
    func willBeginDecelerating(_ block: @escaping (_ scrollView: UIScrollView) -> ()) -> Self {
        manager?.willBeginDecelerating = block
        return self
    }
    @discardableResult
    func didEndDecelerating(_ block: @escaping (_ scrollView: UIScrollView) -> ()) -> Self {
        manager?.didEndDecelerating = block
        return self
    }
    @discardableResult
    func didEndScrollingAnimation(_ block: @escaping (_ scrollView: UIScrollView) -> ()) -> Self {
        manager?.didEndScrollingAnimation = block
        return self
    }
    @discardableResult
    func viewForZooming(_ block: @escaping (_ scrollView: UIScrollView) -> UIView?) -> Self {
        manager?.viewForZooming = block
        return self
    }
    @discardableResult
    func willBeginZooming(_ block: @escaping (_ scrollView: UIScrollView, _ view: UIView?) -> ()) -> Self {
        manager?.willBeginZooming = block
        return self
    }
    @discardableResult
    func didEndZooming(_ block: @escaping (_ scrollView: UIScrollView, _ view: UIView?, _ scale: CGFloat) -> ()) -> Self {
        manager?.didEndZooming = block
        return self
    }
    @discardableResult
    func shouldScrollToTop(_ block: @escaping (_ scrollView: UIScrollView) -> Bool) -> Self {
        manager?.shouldScrollToTop = block
        return self
    }
    @discardableResult
    func didScrollToTop(_ block: @escaping (_ scrollView: UIScrollView) -> ()) -> Self {
        manager?.didScrollToTop = block
        return self
    }
    @available(iOS 11, *)
    @discardableResult
    func didChangeAdjustedContentInset(_ block: @escaping (_ scrollView: UIScrollView) -> ()) -> Self {
        manager?.didChangeAdjustedContentInset = block
        return self
    }
}
