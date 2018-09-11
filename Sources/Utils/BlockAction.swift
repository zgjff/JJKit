// Block 方式来使用UIControl
/*
 let b = UIButton()
 b.jj.handle { [unowned self] _ in //注意此处,一定要使用[unowned self] 或者 [weak sekf],防止循环应用,推荐[unowned self]
   self.dismiss(animated: true, completion: nil)
 }
 navigationItem.rightBarButtonItem = UIBarButtonItem(image: MaterialIcons.close.toImage(), style: .done, block: {
    [unowned self] _ in //注意此处,一定要使用[unowned self] 或者 [weak sekf],防止循环应用,推荐[unowned self]
     self.dis()
 })
 */
import UIKit

extension JJ where Original: UIControl {
    public func handle(state: UIControlEvents? = nil, _ block: @escaping (Original) -> ()) {
        original.handle(block, for: state)
    }
    public func removeAllBlocksForEvents(_ state: UIControlEvents) {
        original.removeAllBlocksForEvents(state)
    }
}

extension JJ where Original: UIGestureRecognizer {
    public func handle(block: @escaping (Original) -> ()) {
        original.handle(block: block)
    }
    public func removeAllBlocks() {
        original.removeAllBlocks()
    }
}

extension UIControl: StoreBlockTargetsable {}

extension StoreBlockTargetsable where Self: UIControl {
    func handle(_ block: @escaping (Self) -> (), for state: UIControlEvents?) {
        var events: UIControlEvents?
        if let state = state {
            events = state
        } else {
            switch self {
            case is UIButton:
                if #available(iOS 9.0, *) {
                    events = .primaryActionTriggered
                } else {
                    events = .touchUpInside
                }
            case is UISlider, is UISegmentedControl, is UISwitch, is UIPageControl, is UIRefreshControl, is UIDatePicker, is UIStepper:
                events = .valueChanged
            case is UITextField: events = .editingChanged
            default: events = nil
            }
        }
        guard let es = events else {
            fatalError("no default events for \(type(of: self))")
        }
        removeAllBlocksForEvents(es)
        let target = BlockTargetInvoke(self, block)
        target.events = es
        addTarget(target, action: #selector(target.invoke), for: es)
        targets.append(target)
    }
    func removeAllBlocksForEvents(_ state: UIControlEvents) {
        guard !targets.isEmpty else {
            return
        }
        let stateRaw = UInt(state.rawValue)
        var needRemoved: [BlockTargetInvoke<Self>] = []
        for target in targets where target.events != nil {
            let tRaw = UInt(target.events!.rawValue)
            if (tRaw & stateRaw) == 0 {
                removeTarget(target, action: #selector(target.invoke), for: target.events!)
                needRemoved.append(target)
            } else {
                let newEvents = UIControlEvents(rawValue: tRaw & (~stateRaw))
                removeTarget(target, action: #selector(target.invoke), for: target.events!)
                target.events = newEvents
                addTarget(target, action: #selector(target.invoke), for: newEvents)
            }
        }
        guard !needRemoved.isEmpty else {
            return
        }
        targets = targets.filter({ target in
            return !needRemoved.contains(target)
        })
    }
}

extension UIGestureRecognizer: StoreBlockTargetsable {}

extension StoreBlockTargetsable where Self: UIGestureRecognizer {
    public init(block: @escaping (Self) -> ()) {
        self.init()
        handle(block: block)
    }
    func handle(block: @escaping (Self) -> ()) {
        let target = BlockTargetInvoke(self, block)
        addTarget(target, action: #selector(target.invoke))
        targets.append(target)
    }
    func removeAllBlocks() {
        guard !targets.isEmpty else {
            return
        }
        for target in targets {
            removeTarget(target, action: #selector(target.invoke))
        }
        targets.removeAll()
    }
}

extension UIBarButtonItem: StoreBlockTargetsable {
    public convenience init(title: String?, style: UIBarButtonItemStyle, block: @escaping (UIBarButtonItem) -> ()) {
        self.init(title: title, style: style, target: nil, action: nil)
        let t = BlockTargetInvoke(self, block)
        target = t
        action = #selector(t.invoke)
        targets.append(t)
    }
    public convenience init(image: UIImage?, style: UIBarButtonItemStyle, block: @escaping (UIBarButtonItem) -> ()) {
        self.init(image: image, style: style, target: nil, action: nil)
        let t = BlockTargetInvoke(self, block)
        target = t
        action = #selector(t.invoke)
        targets.append(t)
    }
    public convenience init(barButtonSystemItem systemItem: UIBarButtonSystemItem, block: @escaping (UIBarButtonItem) -> ()) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        let t = BlockTargetInvoke(self, block)
        target = t
        action = #selector(t.invoke)
        targets.append(t)
    }
}


public protocol StoreBlockTargetsable: NSObjectProtocol {}

private var BlockTargetKeys: Void?
extension StoreBlockTargetsable {
   public var targets: [BlockTargetInvoke<Self>] {
        get {
            return StoreValueManager.get(from: self, key: &BlockTargetKeys, initialiser: { () -> [BlockTargetInvoke<Self>] in
                return []
            })
        }
        set {
            StoreValueManager.set(for: self, key: &BlockTargetKeys, value: newValue)
        }
    }
}


public final class BlockTargetInvoke<T: AnyObject>: NSObject {
    private weak var sender: T?
    private let block: (T) -> ()
    fileprivate var events: UIControlEvents?
    init(_ sender: T, _ block: @escaping (T) -> ()) {
        self.sender = sender
        self.block = block
    }
    
    @IBAction fileprivate func invoke() {
        if let sender = sender {
            block(sender)
        }
    }
}
