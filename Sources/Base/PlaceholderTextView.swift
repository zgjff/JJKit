import UIKit

/// 带placeholder的UITextView
final public class PlaceholderTextView: UITextView {
    @IBInspectable
    public var placeholder: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var placeholderColor: UIColor = UIColor.gray.withAlphaComponent(0.7) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var placeholderFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    public override var text: String! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public override var attributedText: NSAttributedString! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public init() {
        super.init(frame: .zero, textContainer: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }
    
    public init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override public func draw(_ rect: CGRect) {
        guard !hasText else { return }
        guard let placeholder = placeholder else { return }
        let newRect = CGRect(x: 5, y: 8, width: rect.width - 10, height: rect.height)
        (placeholder as NSString).draw(in: newRect, withAttributes: [
            .foregroundColor: placeholderColor,
            .font: placeholderFont
            ])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setNeedsDisplay()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func textDidChange() {
        setNeedsDisplay()
    }
}
