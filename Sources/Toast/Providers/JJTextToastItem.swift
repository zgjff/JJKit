//
//  JJTextToastItem.swift
//  JJKit
//
//  Created by zgjff on 2023/8/8.
//

import UIKit

/// 显示文字的`toast`的默认实现
public final class JJTextToastItem: JJTextToastItemable {
    public weak var delegate: JJToastableDelegate?
    public typealias Options = JJTextToastItem.InnerOptions
    public init(text: String) {
        attributedString = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.white])
    }
    
    public init(attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }
    
    private let attributedString: NSAttributedString
    private var options = Options.init()
    private lazy var label: UILabel = {
       let l = UILabel()
        l.backgroundColor = .clear
        l.textColor = .white
        l.textAlignment = .center
        l.lineBreakMode = .byTruncatingTail
        l.numberOfLines = 0
        return l
    }()
}

// MARK: - JJTextToastItemable
extension JJTextToastItem {
    public func layoutToastView(with options: InnerOptions, inViewSize size: CGSize) {
        self.options = options
        configLabel(with: options)
        resetContentSizeWithViewSize(size)
    }
    
    public func resetContentSizeWithViewSize(_ size: CGSize) {
        let maxSize = options.maxSize(size)
        let (lsize, vsize) = calculationSize(with: options.margin, maxSize: maxSize)
        label.frame = CGRect(origin: CGPoint(x: options.margin.left, y: options.margin.top), size: lsize)
        delegate?.didCalculationView(label, viewSize: vsize, sender: self)
    }
}

// MARK: - private
private extension JJTextToastItem {
    func configLabel(with options: InnerOptions) {
        options.configLabel?(label)
        if options.lineSpacing <= 0 {
            label.attributedText = attributedString
            return
        }
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
            paragraphStyle.lineSpacing = options.lineSpacing >= 0 ? options.lineSpacing : paragraphStyle.lineSpacing
            att.addAttribute(.paragraphStyle, value: paragraphStyle, range: subRange)
        }
        label.attributedText = att
    }
    
    func calculationSize(with margin: UIEdgeInsets, maxSize: CGSize) -> (CGSize, CGSize) {
        let labelMaxSize = CGSize(width: maxSize.width - margin.left - margin.right, height: maxSize.height - margin.top - margin.bottom)
        var labelSize = label.sizeThatFits(labelMaxSize)
        labelSize.width = labelSize.width > labelMaxSize.width ? labelMaxSize.width : labelSize.width
        labelSize.height = labelSize.height > labelMaxSize.height ? labelMaxSize.height : labelSize.height
        let w = labelSize.width + margin.left + margin.right
        let h = labelSize.height + margin.top + margin.bottom
        let viewSize = CGSize(width: w, height: h)
        return (labelSize, viewSize)
    }
}

// MARK: - 文字配置
extension JJTextToastItem {
    /// 文字`taost`配置项
    public struct InnerOptions: JJToastItemOptions {
        public init() {}
        
        /// 通过block方式设置label的属性
        public var configLabel: ((UILabel) -> ())?
        
        /// 多行显示时的文字行间隔。默认为6；少于0无效；
        ///
        /// 设置此项,可能会导致`TextToastProvider`通过`init(attributedString: NSAttributedString)`方式初始化时,设置的`paragraphStyle`行间距无效
        public var lineSpacing: CGFloat = 6
        
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
