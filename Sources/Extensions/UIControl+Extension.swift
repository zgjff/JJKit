import UIKit

private var touchDown_JJBlockKey = 0
private var touchDownRepeat_JJBlockKey = 0
private var touchDragInside_JJBlockKey = 0
private var touchDragOutside_JJBlockKey = 0
private var touchDragEnter_JJBlockKey = 0
private var touchDragExit_JJBlockKey = 0
private var touchUpInside_JJBlockKey = 0
private var touchUpOutside_JJBlockKey = 0
private var touchCancel_JJBlockKey = 0
private var valueChanged_JJBlockKey = 0
private var primaryActionTriggered_JJBlockKey = 0
private var editingDidBegin_JJBlockKey = 0
private var editingChanged_JJBlockKey = 0
private var editingDidEnd_JJBlockKey = 0
private var editingDidEndOnExit_JJBlockKey = 0
private var allTouchEvents_JJBlockKey = 0
private var allEditingEvents_JJBlockKey = 0
private var applicationReserved_JJBlockKey = 0
private var systemReserved_JJBlockKey = 0
private var allEvents_JJBlockKey = 0

extension JJ where Object: UIControl {
    public func addBlockHandler(for event: UIControl.Event, handler: @escaping (Object) -> Void) {
        switch event {
        case .touchDown:
            privateAddBlockHandler(event: event, handler: handler, key: &touchDown_JJBlockKey)
        case .touchDownRepeat:
            privateAddBlockHandler(event: event, handler: handler, key: &touchDownRepeat_JJBlockKey)
        case .touchDragInside:
            privateAddBlockHandler(event: event, handler: handler, key: &touchDragInside_JJBlockKey)
        case .touchDragOutside:
            privateAddBlockHandler(event: event, handler: handler, key: &touchDragOutside_JJBlockKey)
        case .touchDragEnter:
            privateAddBlockHandler(event: event, handler: handler, key: &touchDragEnter_JJBlockKey)
        case .touchDragExit:
            privateAddBlockHandler(event: event, handler: handler, key: &touchDragExit_JJBlockKey)
        case .touchUpInside:
            privateAddBlockHandler(event: event, handler: handler, key: &touchUpInside_JJBlockKey)
        case .touchUpOutside:
            privateAddBlockHandler(event: event, handler: handler, key: &touchUpOutside_JJBlockKey)
        case .touchCancel:
            privateAddBlockHandler(event: event, handler: handler, key: &touchCancel_JJBlockKey)
        case .valueChanged:
            privateAddBlockHandler(event: event, handler: handler, key: &valueChanged_JJBlockKey)
        case .primaryActionTriggered:
            privateAddBlockHandler(event: event, handler: handler, key: &primaryActionTriggered_JJBlockKey)
        case .editingDidBegin:
            privateAddBlockHandler(event: event, handler: handler, key: &editingDidBegin_JJBlockKey)
        case .editingChanged:
            privateAddBlockHandler(event: event, handler: handler, key: &editingChanged_JJBlockKey)
        case .editingDidEnd:
            privateAddBlockHandler(event: event, handler: handler, key: &editingDidEnd_JJBlockKey)
        case .editingDidEndOnExit:
            privateAddBlockHandler(event: event, handler: handler, key: &editingDidEndOnExit_JJBlockKey)
        case .allTouchEvents:
            privateAddBlockHandler(event: event, handler: handler, key: &allTouchEvents_JJBlockKey)
        case .allEditingEvents:
            privateAddBlockHandler(event: event, handler: handler, key: &allEditingEvents_JJBlockKey)
        case .applicationReserved:
            privateAddBlockHandler(event: event, handler: handler, key: &applicationReserved_JJBlockKey)
        case .systemReserved:
            privateAddBlockHandler(event: event, handler: handler, key: &systemReserved_JJBlockKey)
        case .allEvents:
            privateAddBlockHandler(event: event, handler: handler, key: &allEvents_JJBlockKey)
        default:
            return
        }
    }
    
    private func privateAddBlockHandler(event: UIControl.Event, handler: @escaping (Object) -> Void, key: UnsafePointer<Int>) {
        let ch: ControlHandler
        if let getch = objc_getAssociatedObject(object, key) as? ControlHandler {
            object.removeTarget(getch, action: #selector(getch.invoke), for: event)
            ch = getch
        } else {
            ch = ControlHandler(target: object, event: event)
            objc_setAssociatedObject(object, key, ch, .OBJC_ASSOCIATION_RETAIN)
        }
        ch.handler = { c in
            handler(c as! Object)
        }
        object.addTarget(ch, action: #selector(ch.invoke), for: event)
    }
    
    public func removeBlockHandler(for event: UIControl.Event) {
        switch event {
        case .touchDown:
            privateremoveBlockHandler(for: event, key: &touchDown_JJBlockKey)
        case .touchDownRepeat:
            privateremoveBlockHandler(for: event, key: &touchDownRepeat_JJBlockKey)
        case .touchDragInside:
            privateremoveBlockHandler(for: event, key: &touchDragInside_JJBlockKey)
        case .touchDragOutside:
            privateremoveBlockHandler(for: event, key: &touchDragOutside_JJBlockKey)
        case .touchDragEnter:
            privateremoveBlockHandler(for: event, key: &touchDragEnter_JJBlockKey)
        case .touchDragExit:
            privateremoveBlockHandler(for: event, key: &touchDragExit_JJBlockKey)
        case .touchUpInside:
            privateremoveBlockHandler(for: event, key: &touchUpInside_JJBlockKey)
        case .touchUpOutside:
            privateremoveBlockHandler(for: event, key: &touchUpOutside_JJBlockKey)
        case .touchCancel:
            privateremoveBlockHandler(for: event, key: &touchCancel_JJBlockKey)
        case .valueChanged:
            privateremoveBlockHandler(for: event, key: &valueChanged_JJBlockKey)
        case .primaryActionTriggered:
            privateremoveBlockHandler(for: event, key: &primaryActionTriggered_JJBlockKey)
        case .editingDidBegin:
            privateremoveBlockHandler(for: event, key: &editingDidBegin_JJBlockKey)
        case .editingChanged:
            privateremoveBlockHandler(for: event, key: &editingChanged_JJBlockKey)
        case .editingDidEnd:
            privateremoveBlockHandler(for: event, key: &editingDidEnd_JJBlockKey)
        case .editingDidEndOnExit:
            privateremoveBlockHandler(for: event, key: &editingDidEndOnExit_JJBlockKey)
        case .allTouchEvents:
            privateremoveBlockHandler(for: event, key: &allTouchEvents_JJBlockKey)
        case .allEditingEvents:
            privateremoveBlockHandler(for: event, key: &allEditingEvents_JJBlockKey)
        case .applicationReserved:
            privateremoveBlockHandler(for: event, key: &applicationReserved_JJBlockKey)
        case .systemReserved:
            privateremoveBlockHandler(for: event, key: &systemReserved_JJBlockKey)
        case .allEvents:
            privateremoveBlockHandler(for: event, key: &allEvents_JJBlockKey)
        default:
            return
        }
    }
    
    public func removeAllEventBlockHandler() {
        privateremoveBlockHandler(for: .touchDown, key: &touchDown_JJBlockKey)
        privateremoveBlockHandler(for: .touchDownRepeat, key: &touchDownRepeat_JJBlockKey)
        privateremoveBlockHandler(for: .touchDragInside, key: &touchDragInside_JJBlockKey)
        privateremoveBlockHandler(for: .touchDragOutside, key: &touchDragOutside_JJBlockKey)
        privateremoveBlockHandler(for: .touchDragEnter, key: &touchDragEnter_JJBlockKey)
        privateremoveBlockHandler(for: .touchDragExit, key: &touchDragExit_JJBlockKey)
        privateremoveBlockHandler(for: .touchUpInside, key: &touchUpInside_JJBlockKey)
        privateremoveBlockHandler(for: .touchUpOutside, key: &touchUpOutside_JJBlockKey)
        privateremoveBlockHandler(for: .touchCancel, key: &touchCancel_JJBlockKey)
        privateremoveBlockHandler(for: .valueChanged, key: &valueChanged_JJBlockKey)
        privateremoveBlockHandler(for: .primaryActionTriggered, key: &primaryActionTriggered_JJBlockKey)
        privateremoveBlockHandler(for: .editingDidBegin, key: &editingDidBegin_JJBlockKey)
        privateremoveBlockHandler(for: .editingChanged, key: &editingChanged_JJBlockKey)
        privateremoveBlockHandler(for: .editingDidEnd, key: &editingDidEnd_JJBlockKey)
        privateremoveBlockHandler(for: .editingDidEndOnExit, key: &editingDidEndOnExit_JJBlockKey)
        privateremoveBlockHandler(for: .allTouchEvents, key: &allTouchEvents_JJBlockKey)
        privateremoveBlockHandler(for: .allEditingEvents, key: &allEditingEvents_JJBlockKey)
        privateremoveBlockHandler(for: .applicationReserved, key: &applicationReserved_JJBlockKey)
        privateremoveBlockHandler(for: .systemReserved, key: &systemReserved_JJBlockKey)
        privateremoveBlockHandler(for: .allEvents, key: &allEvents_JJBlockKey)
    }
    
    private func privateremoveBlockHandler(for event: UIControl.Event, key: UnsafePointer<Int>) {
        if let getch = objc_getAssociatedObject(object, key) as? ControlHandler {
            object.removeTarget(getch, action: #selector(getch.invoke), for: event)
            objc_setAssociatedObject(object, key, nil, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

fileprivate class ControlHandler {
    let target: UIControl
    let event: UIControl.Event
    var handler: ((UIControl) -> Void)?
    init(target: UIControl, event: UIControl.Event) {
        self.target = target
        self.event = event
    }
    
    @objc func invoke() {
        handler?(target)
    }
}
