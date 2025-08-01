//
//  JJCarouselView.swift
//  JJCarouselView
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

/// 展示`UIImage`的轮播图别名
public typealias JJLocalImageCarouselView = JJCarouselView<UIImageView, UIImage>

/// 展示网络图片的轮播图别名
public typealias JJWebImageCarouselView = JJCarouselView<UIImageView, URL>

/// 轮播图组件
public final class JJCarouselView<Cell: UIView, Object: Equatable>: UIView {
    /// 配置
    public var config = Config()
    
    /// 数据源
    public var datas: [Object] = [] {
        didSet {
            onGetDatas(old: oldValue, new: datas)
        }
    }
    /// 事件回调
    public var event = Event()
    
    /// 用于设置轮播图的指示器
    public var pageView: JJCarouselViewPageable = JJCarouselDotPageView() {
        didSet {
            oldValue.removeFromSuperview()
            pageView.numberOfPages = datas.count
            addSubview(pageView)
            bringSubviewToFront(pageView)
        }
    }
    
    /// 初始化
    /// - Parameters:
    ///   - frame: frame
    ///   - initialize: 初始化单个cell的方法。如果`nil`,则按照其初始化方法`init(frame: CGRect)`来初始化
    ///   - style: 轮播图风格,默认`full`平铺风格
    public init(frame: CGRect, initialize: (() -> Cell)?, style: Style = .full) {
        containerView = style.createContainerView(frame: frame, initialize: initialize)
        super.init(frame: frame)
        containerView.dataSource = self
        containerView.delegate = self
        addSubview(containerView)
        addSubview(pageView)
        addObservers()
    }
    
    public override init(frame: CGRect) {
        containerView = Style.full.createContainerView(frame: .zero, initialize: nil)
        super.init(frame: frame)
        containerView.dataSource = self
        containerView.delegate = self
        addSubview(containerView)
        addSubview(pageView)
        addObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 组件
    private let containerView: JJCarouselContainerView
    
    // MARK: - 属性
    private var preScrollcontentOffset = CGPoint.zero
    private var timer: Timer?
    private var didEnterBackgroundObserver: NSObjectProtocol?
    private var willEnterForegroundObserver: NSObjectProtocol?
    
    deinit {
        removeObservers()
        destoryTimer()
    }
    
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            scrollViewWillBeginDragging()
        } else {
            scrollViewDidEndDecelerating()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = bounds
        pageView.frame = config.pageViewFrame(pageView, config.direction, bounds.size, datas.count)
    }
    
    // MARK: - 私有方法
    
    /// 重启定时器
    @IBAction private func resumeTimer() {
        timer?.fireDate = Date()
    }
    
    @IBAction private func loopTimer_below10() {
        if !datas.isEmpty {
            containerView.needAutoScrollToNextIndex()
        }
    }
}

// MARK: - JJCarouselContainerViewDataSource, JJCarouselContainerViewDelegate
extension JJCarouselView: JJCarouselContainerViewDataSource, JJCarouselContainerViewDelegate {
    func loopDirection() -> JJCarousel.Direction {
        return config.direction
    }
    
    func numberOfDatas() -> Int {
        return datas.count
    }
    
    func cellContentInset() -> UIEdgeInsets {
        return config.contentInset
    }
    
    func displayCell(_ cell: UIView, atIndex index: Int) {
        if let cell = cell as? Cell {
            config.display?(cell, datas[index])
        }
    }
    
    func onClickCell(_ cell: UIView, atIndex index: Int) {
        if let cell = cell as? Cell {
            event.onTapFunction(view: cell, object: datas[index], index: index)
        }
    }
    
    func willScroll(to index: Int) {
        event.willMoveFunction(index: index)
    }
    
    func onScroll(from fromIndex: Int, to toIndex: Int, progress: Float) {
        event.onScrollFunction(fronIndex: fromIndex, toIndex: toIndex, progress: progress)
        pageView.onScroll(from: fromIndex, to: toIndex, progress: progress)
    }
    
    func didScroll(to index: Int) {
        pageView.currentPage = index
        event.didMoveFunction(index: index)
    }
    
    func scrollViewWillBeginDragging() {
        if config.autoLoop {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(resumeTimer), object: nil)
            pauseTimer()
        }
    }
    
    func scrollViewDidEndDecelerating() {
        if config.autoLoop {
            /// 先取消,再重启....防止多次重启
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(resumeTimer), object: nil)
            perform(#selector(resumeTimer), with: nil, afterDelay: config.loopTimeInterval)
        }
    }
}

// MARK: - private
private extension JJCarouselView {
    func onGetDatas(old: [Object], new: [Object]) {
        if old.count != new.count {
            onGetDifferentDatas()
            return
        }
        if new.isEmpty {
            return
        }
        let isSame = new.elementsEqual(old, by: { $0 == $1 })
        if !isSame {
            onGetDifferentDatas()
        }
    }
    
    func onGetDifferentDatas() {
        pageView.numberOfPages = datas.count
        if !bounds.isEmpty {
            pageView.frame = config.pageViewFrame(pageView, config.direction, bounds.size, datas.count)
        }
        containerView.reload()
        if datas.count > 1 {
            destoryTimer()
            createTimer()
        } else {
            destoryTimer()
        }
    }
}

// MARK: - NotificationCenter相关
private extension JJCarouselView {
    func addObservers() {
        didEnterBackgroundObserver = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.scrollViewWillBeginDragging()
        })
        willEnterForegroundObserver = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let self = self else {
                return
            }
            if self.config.autoLoop && (self.window != nil) {
                self.timer?.fireDate = Date().addingTimeInterval(self.config.loopTimeInterval)
            }
        })
    }
    
    func removeObservers() {
        if let didEnterBackgroundObserver = didEnterBackgroundObserver {
            NotificationCenter.default.removeObserver(didEnterBackgroundObserver)
        }
        if let willEnterForegroundObserver = willEnterForegroundObserver {
            NotificationCenter.default.removeObserver(willEnterForegroundObserver)
        }
    }
}

// MARK: - timer相关
private extension JJCarouselView {
    func createTimer() {
        if !config.autoLoop {
            return
        }
        if #available(iOS 10.0, *) {
            let timer = Timer(fire: Date().addingTimeInterval(config.loopTimeInterval), interval: config.loopTimeInterval, repeats: true) { [weak self] _ in
                guard let self = self, !self.datas.isEmpty else {
                    return
                }
                self.containerView.needAutoScrollToNextIndex()
            }
            self.timer = timer
            RunLoop.current.add(timer, forMode: .common)
        } else {
            let timer = Timer(fireAt: Date().addingTimeInterval(config.loopTimeInterval), interval: config.loopTimeInterval, target: self, selector: #selector(loopTimer_below10), userInfo: nil, repeats: true)
            self.timer = timer
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    func pauseTimer() {
        timer?.fireDate = .distantFuture
    }
    
    func destoryTimer() {
        timer?.invalidate()
        timer = nil
    }
}
