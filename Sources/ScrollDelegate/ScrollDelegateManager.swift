import UIKit

internal class ScrollDelegateManager: NSObject {    
    internal var didScroll: ((UIScrollView) -> ())?
    internal var didZoom: ((UIScrollView) -> ())?
    internal var willBeginDragging: ((UIScrollView) -> ())?
    internal var willEndDragging: ((UIScrollView, CGPoint, UnsafeMutablePointer<CGPoint>) -> ())?
    internal var didEndDragging: ((UIScrollView, Bool) -> ())?
    internal var willBeginDecelerating: ((UIScrollView) -> ())?
    internal var didEndDecelerating: ((UIScrollView) -> ())?
    internal var didEndScrollingAnimation: ((UIScrollView) -> ())?
    internal var viewForZooming: ((UIScrollView) -> UIView?)?
    internal var willBeginZooming: ((UIScrollView, UIView?) -> ())?
    internal var didEndZooming: ((UIScrollView, UIView?, CGFloat) -> ())?
    internal var shouldScrollToTop: ((UIScrollView) -> Bool)?
    internal var didScrollToTop: ((UIScrollView) -> ())?
    internal var didChangeAdjustedContentInset: ((UIScrollView) -> ())?
}

extension ScrollDelegateManager: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        didZoom?(scrollView)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        willBeginDragging?(scrollView)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        willEndDragging?(scrollView, velocity, targetContentOffset)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didEndDragging?(scrollView, decelerate)
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        willBeginDecelerating?(scrollView)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndDecelerating?(scrollView)
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        didEndScrollingAnimation?(scrollView)
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return viewForZooming?(scrollView)
    }
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        willBeginZooming?(scrollView, view)
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        didEndZooming?(scrollView, view, scale)
    }
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return shouldScrollToTop?(scrollView) ?? true
    }
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        didScrollToTop?(scrollView)
    }
    @available(iOS 11.0, *)
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        didChangeAdjustedContentInset?(scrollView)
    }
}
