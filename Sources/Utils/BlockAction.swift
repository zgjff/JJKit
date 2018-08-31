import UIKit

extension JJ where Original: UIControl {
    public func handle(_ block: @escaping (Original) -> (), for state: UIControlEvents? = nil) {
        original.handle(block, for: state)
    }
    public func removeAllBlocksForEvents(_ state: UIControlEvents) {
        original.removeAllBlocksForEvents(state)
    }
}


public protocol StoreBlockTargetsable: NSObjectProtocol {}

private var BlockTargetKeys: Void?
extension StoreBlockTargetsable {
    var targets: [BlockTargetInvoke<Self>] {
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


extension StoreBlockTargetsable where Self: UIControl {
    func handle(_ block: @escaping (Self) -> (), for state: UIControlEvents? = nil) {
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

extension UIControl: StoreBlockTargetsable {}

class BlockTargetInvoke<T: AnyObject>: NSObject {
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
    deinit {
        print("BlockTargetInvoke  deinit")
    }
}
