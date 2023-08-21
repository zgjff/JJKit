//
//  JJVaryTextToastItem.swift
//  JJKit
//
//  Created by zgjff on 2023/8/14.
//

import UIKit

/// 显示变化的文字的`toast`样式
public final class JJVaryTextToastItem: JJTextToastItemable {
    public weak var delegate: JJToastableDelegate?
    public let identifier = JJToastItemIdentifiers.varyText.identifier
    public typealias Options = JJVaryTextToastItem.InnerOptions
    /// 初始化文字初始化: 默认白色、字号17
    /// - Parameter text: 文字内容: 如果数组个数小于等于1的话,将不会触发任何配置选项中的循环设置
    public init(texts: [String]) {
        attributedStrings = texts.map { NSAttributedString(string: $0, attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.white]) }
    }
    
    /// 使用富文本数组初始化
    /// - Parameter attributedStrings: 富文本数组: 如果数组个数小于等于1的话,将不会触发任何配置选项中的循环设置
    public init(attributedStrings: [NSAttributedString]) {
        self.attributedStrings = attributedStrings
    }
    
    private var attributedStrings: [NSAttributedString]
    public private(set) lazy var options = Options.init()
    private lazy var label: UILabel = {
       let l = UILabel()
        l.backgroundColor = .clear
        l.textColor = .white
        l.textAlignment = .center
        l.lineBreakMode = .byTruncatingTail
        l.numberOfLines = 0
        return l
    }()
    /// 当前展示的内容
    private var currentDisplayIndex = 0
    private var timer: Timer?
    deinit {
        stopTimer()
    }
}

// MARK: - JJTextToastItemable
extension JJVaryTextToastItem {
    public func layoutToastView(with options: InnerOptions, inViewSize size: CGSize) {
        stopTimer()
        self.options = options
        configLabel(with: options)
        resetContentSizeWithViewSize(size)
        startTimer()
    }
    
    public func resetContentSizeWithViewSize(_ size: CGSize) {
        if attributedStrings.isEmpty {
            delegate?.didCalculationView(label, viewSize: CGSize(width: options.margin.left + options.margin.right, height: options.margin.top + options.margin.bottom), sender: self)
            return
        }
        var maxSize = (CGSize.zero, CGSize.zero)
        for att in attributedStrings {
            label.attributedText = att
            let (lsize, vsize) = calculationSize(with: options.margin, maxSize: options.maxSize(size))
            if lsize.width > maxSize.0.width || lsize.height > maxSize.0.height {
                maxSize = (lsize, vsize)
            }
        }
        label.frame = CGRect(origin: CGPoint(x: options.margin.left, y: options.margin.top), size: maxSize.0)
        let idx = currentDisplayIndex % attributedStrings.count
        display(text: attributedStrings[idx], in: label)
        delegate?.didCalculationView(label, viewSize: maxSize.1, sender: self)
    }
    
    public func display(text: NSAttributedString, in labelToShow: UILabel) {
        labelToShow.attributedText = text
    }
}

// MARK: - private
private extension JJVaryTextToastItem {
    func configLabel(with options: InnerOptions) {
        options.configLabel?(label)
        if attributedStrings.isEmpty {
            return
        }
        var attrs: [NSAttributedString] = []
        for attributedString in attributedStrings {
            let str = attributedString.string
            let att = NSMutableAttributedString(attributedString: attributedString)
            let range = str.jj.nsRange(from: str.startIndex..<str.endIndex)
            attributedString.enumerateAttribute(.paragraphStyle, in: range, options: []) { [weak self] value, subRange, _ in
                guard let self = self else {
                    return
                }
                let paragraphStyle: NSMutableParagraphStyle
                if let mutableStyle = value as? NSMutableParagraphStyle {
                    paragraphStyle = mutableStyle
                } else if let style = value as? NSParagraphStyle {
                    let obj = NSMutableParagraphStyle()
                    obj.setParagraphStyle(style)
                    paragraphStyle = obj
                } else {
                    paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = self.label.textAlignment
                    paragraphStyle.lineBreakMode = self.label.lineBreakMode
                }
                paragraphStyle.lineSpacing = options.lineSpacing > 0 ? options.lineSpacing : paragraphStyle.lineSpacing
                att.addAttribute(.paragraphStyle, value: paragraphStyle, range: subRange)
            }
            attrs.append(att)
        }
        attributedStrings = attrs
    }
    
    func calculationSize(with margin: UIEdgeInsets, maxSize: CGSize) -> (CGSize, CGSize) {
        let labelMaxSize = CGSize(width: maxSize.width - margin.left - margin.right, height: maxSize.height - margin.top - margin.bottom)
        let textSize = label.sizeThatFits(labelMaxSize)
        var labelSize = CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
        labelSize.width = labelSize.width > labelMaxSize.width ? labelMaxSize.width : labelSize.width
        labelSize.height = labelSize.height > labelMaxSize.height ? labelMaxSize.height : labelSize.height
        let w = labelSize.width + margin.left + margin.right
        let h = labelSize.height + margin.top + margin.bottom
        let viewSize = CGSize(width: w, height: h)
        return (labelSize, viewSize)
    }
    
    func startTimer() {
        if attributedStrings.count <= 1 {
            return
        }
        let t = Timer(timeInterval: options.displayDuration, repeats: true, block: { [weak self] _ in
            guard let self else {
                return
            }
            let allCount = self.attributedStrings.count
            let idx = self.currentDisplayIndex + 1
            if idx % allCount == 0 { // 一次循环完毕
                let loopCount = idx / allCount
                self.options.varyLoopHandler?(loopCount)
                if loopCount >= self.options.loopCount, self.options.loopCount > 0 { // 次数到了,停止循环
                    self.stopTimer()
                    if self?.options.autoDismissWhenLoopCompletion {
                        self?.delegate?.triggerAutoDismiss(sender: self, animated: true)
                    }
                    return
                }
            }
            self.display(text: self.attributedStrings[idx % allCount], in: self.label)
            self.currentDisplayIndex = idx
        })
        RunLoop.main.add(t, forMode: .common)
        t.fireDate = Date(timeIntervalSinceNow: options.displayDuration)
        timer = t
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - 文字配置
extension JJVaryTextToastItem {
    /// 文字`taost`配置项
    public struct InnerOptions: JJToastItemOptions {
        public init() {}
        public var sameToastItemTypeStrategy: JJSameToastItemTypeStrategy = JJReplaceToastWithOutAnimatorStrategy()
        /// 循环次数: 小于等于0的话,是无限制循环下去
        public var loopCount = 0
        /// 单次展示时间
        public var displayDuration: TimeInterval = 1.0
        /// 单次循环完成回调
        public var varyLoopHandler: ((_ loopCount: Int) -> ())?
        /// 循环次数完毕是否自动隐藏
        public var autoDismissWhenLoopCompletion = true
        /// 通过block方式设置label的属性
        public var configLabel: ((UILabel) -> ())?
        /// 多行显示时的文字行间隔。默认为5；少于0无效；
        /// 小于等于0,使用系统的间距
        ///
        /// 设置此项,可能会导致`TextToastProvider`通过`init(attributedStrings: [NSAttributedString])`方式初始化时,设置的`paragraphStyle`行间距无效
        public var lineSpacing: CGFloat = 5
        /// 文字对齐方式
        public var textAlignment = NSTextAlignment.center
        /// 设置文字label外边距
        public var margin = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        /// 设置内容区域的最大size
        public var maxSize: (_ viewSize: CGSize) -> (CGSize) = { viewSize in
            if viewSize.width == 0 || viewSize.height == 0 {
                return .zero
            }
            return CGSize(width: viewSize.width * 0.8, height: viewSize.height * 0.8)
        }
    }
}
