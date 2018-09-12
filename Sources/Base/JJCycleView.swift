//
//  无限循环轮播图
//  本轮播图不限制所用的第三方，你可以通过使用第三方或者自定义下载显示url图片，只需要实现CycleViewImageSource协议中的方法
//  eg: 使用Kingfisher
/*
 extension URL: CycleViewImageSource {
   func showInView(_ view: UIImageView) {
     view.kf.setImage(with: URL(string: url))
   }
 }
 */
import UIKit

public class JJCycleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        addSubview(scrollView)
        insertSubview(pageControl, aboveSubview: scrollView)
        scrollView.delegate = self
    }
    
    public weak var delegate: JJCycleViewDataDelegate?
    public var timeInterval: TimeInterval = 5
    public var pageControlColor = UIColor.gray {
        didSet { pageControl.pageIndicatorTintColor = pageControlColor }
    }
    public var pageControlCurrentColor = UIColor.white {
        didSet { pageControl.currentPageIndicatorTintColor = pageControlCurrentColor }
    }
    public var imageContentMode: UIViewContentMode = .scaleAspectFill {
        didSet {
            leftImageView.contentMode = imageContentMode
            midImageView.contentMode = imageContentMode
            rightImageView.contentMode = imageContentMode
        }
    }
    
    private var imgSources: [CycleViewImageSource] = [] {
        willSet {
            timer?.cancel()
            timer = nil
            scrollView.jj.removeAll()
            currentIndex = 0
        }
        didSet {
            resetScrollContent()
            pageControl.numberOfPages = imgSources.count
            if imgSources.count > 1 {
                timer = GCDTimer(repeating: timeInterval, block: { [weak self] _ in
                    DispatchQueue.main.async {
                        guard let `self` = self else { return }
                        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.jj.width * 2, y: 0), animated: true)
                    }
                })
                timer?.resume(after: timeInterval)
            }
        }
    }
    
    private var currentIndex = 0 {
        didSet {
            pageControl.currentPage = currentIndex
            switch imgSources.count {
            case 0:
                return
            case 1:
                imgSources.first?.showInView(leftImageView)
                leftImageView.imageIndex = 0
            case 2:
                let next = ((currentIndex + 1) == imgSources.count) ? 0 : (currentIndex + 1)
                imgSources[next].showInView(leftImageView)
                imgSources[currentIndex].showInView(midImageView)
                imgSources[next].showInView(rightImageView)
                leftImageView.imageIndex = next
                midImageView.imageIndex = currentIndex
                rightImageView.imageIndex = next
            default:
                let next = ((currentIndex + 1) == imgSources.count) ? 0 : (currentIndex + 1)
                let pre = (currentIndex == 0) ? (imgSources.count - 1) : (currentIndex - 1)
                imgSources[pre].showInView(leftImageView)
                imgSources[currentIndex].showInView(midImageView)
                imgSources[next].showInView(rightImageView)
                leftImageView.imageIndex = pre
                midImageView.imageIndex = currentIndex
                rightImageView.imageIndex = next
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var timer: GCDTimer?
    private lazy var scrollView = UIScrollView().jj.config {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.bounces = false
    }
    private lazy var leftImageView = CycleItemView()
    private lazy var midImageView = CycleItemView()
    private lazy var rightImageView = CycleItemView()
    private lazy var pageControl = UIPageControl().jj.config {
        $0.hidesForSinglePage = true
        $0.pageIndicatorTintColor = pageControlColor
        $0.currentPageIndicatorTintColor = pageControlCurrentColor
    }
    deinit {
        timer?.cancel()
        timer = nil
    }
}

extension JJCycleView {
    public func reloadData() {
        guard let delegate = delegate else { return }
        imgSources = delegate.imageSources(for: self)
    }
    private func resetScrollContent() {
        let c = imgSources.count
        var i = 1
        switch c {
        case 0:
            i = 1
        case 1:
            i = 1
            leftImageView.jj.left = 0
            scrollView.addSubview(leftImageView)
            imgSources.first?.showInView(leftImageView)
            scrollView.contentOffset = .zero
        default:
            i = 3
            leftImageView.jj.left = 0
            midImageView.jj.left = scrollView.jj.width
            rightImageView.jj.left = scrollView.jj.width * 2
            scrollView.jj.addViews(leftImageView, midImageView, rightImageView)
            scrollView.setContentOffset(CGPoint(x: jj.width, y: 0), animated: false)
        }
        currentIndex = 0
        scrollView.contentSize = CGSize(width: jj.width * CGFloat(i), height: jj.height)
        
        scrollView.subviews
            .filter { type(of: $0) == CycleItemView.self }
            .forEach { v in
                guard let v = v as? CycleItemView else { return }
                v.tap = { [unowned self] i in
                    self.delegate?.cycleView(self, didSelectIndex: i)
                }
        }
    }
    /// GCD重新计时
    @IBAction private func restart() {
        timer?.resume()
    }
}

// MARK: - UIScrollViewDelegate
extension JJCycleView: UIScrollViewDelegate {
    /// 当手指开始滑动
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.suspend()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(restart), object: nil)
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        if offset == jj.width * 2 {
            currentIndex = (currentIndex == imgSources.count - 1) ? 0 : (currentIndex + 1)
            scrollView.setContentOffset(CGPoint(x: jj.width, y: 0), animated: false)
        } else if offset == 0 {
            currentIndex = (currentIndex == 0) ? (imgSources.count - 1) : (currentIndex - 1)
            scrollView.setContentOffset(CGPoint(x: jj.width, y: 0), animated: false)
        }
    }
    /// 手指滑动停止后调用
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        perform(#selector(restart), with: nil, afterDelay: timeInterval)
    }
    /// 滚动视图动画完成后（setContentOffset: animated: true 的时候才触发）
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {}
}

extension JJCycleView {
    public override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.jj
            .width(is: jj.width)
            .height(is: jj.height)
        
        pageControl.jj
            .width(is: jj.width)
            .height(is: 30)
            .bottom(is: jj.height)
        
        leftImageView.jj
            .width(is: scrollView.jj.width)
            .height(is: scrollView.jj.height)
        
        midImageView.jj
            .width(is: scrollView.jj.width)
            .height(is: scrollView.jj.height)
        
        rightImageView.jj
            .width(is: scrollView.jj.width)
            .height(is: scrollView.jj.height)
    }
}

private class CycleItemView: UIImageView {
    var imageIndex = 0
    var tap: ((Int) -> ())?
    init() {
        super.init(frame: .zero)
        clipsToBounds = true
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFill
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBAction private func click() {
        tap?(imageIndex)
    }
}

public protocol CycleViewImageSource {
    func showInView(_ view: UIImageView)
}

extension UIImage: CycleViewImageSource {
    public func showInView(_ view: UIImageView) {
        view.image = self
    }
}

/// 轮播图数据代理
public protocol JJCycleViewDataDelegate: NSObjectProtocol {
    func imageSources(for cycleView: JJCycleView) -> [CycleViewImageSource]
    func cycleView(_ cycleView: JJCycleView, didSelectIndex index: Int)
}

extension JJCycleViewDataDelegate {
    func cycleView(_ cycleView: JJCycleView, didSelectIndex index: Int) {}
}
