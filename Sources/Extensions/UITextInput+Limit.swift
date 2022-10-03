//
//  UITextInput+Limit.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

extension JJBox where Base: UITextField {
    /// UITextField是否应该继续输入内容
    /// - Parameters:
    ///   - string: 内容
    ///   - range: 范围
    ///   - maxCount: 字数限制
    /// - Returns: 是否继续输入
    func shouldChangeCharactersWithReplacementString(_ string: String, range: NSRange, maxCount: Int) -> Bool {
        if !base.hasObservedEditingChanged {
            base.maxTextLimitCount = maxCount
            base.addEditingChangedObserve()
            base.hasObservedEditingChanged = true
        }
        return base.private_shouldChangeCharactersWithReplacementString(string, range: range, maxCount: maxCount, currentInputText: base.text ?? "") { str in
            self.base.text = str
        } afterResetText: {
            self.base.sendActions(for: .editingChanged)
            NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: self.base)
        }
    }
}

extension JJBox where Base: UITextView {
    /// UITextView是否应该继续输入内容
    /// - Parameters:
    ///   - string: 内容
    ///   - range: 范围
    ///   - maxCount: 字数限制
    /// - Returns: 是否继续输入
    func shouldChangeCharactersWithReplacementString(_ string: String, range: NSRange, maxCount: Int) -> Bool {
        if !base.hasObservedEditingChanged {
            base.maxTextLimitCount = maxCount
            base.hasObservedEditingChanged = true
        }
        return base.private_shouldChangeCharactersWithReplacementString(string, range: range, maxCount: maxCount, currentInputText: base.text) { str in
            self.base.text = str
        } afterResetText: {
            NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: self.base)
        }
    }
}

extension UITextField {
    fileprivate func addEditingChangedObserve() {
        addTarget(self, action: #selector(onChangeEditing), for: .editingChanged)
    }
    
    @IBAction private func onChangeEditing() {
        if let undo = undoManager, undo.isUndoing || undo.isRedoing {
            return
        }
        if markedTextRange != nil {
            return
        }
        let ctext = text ?? ""
        if ctext.count <= maxTextLimitCount {
            return
        }
        let subStart = ctext.startIndex
        let subEnd = ctext.index(subStart, offsetBy: maxTextLimitCount)
        let crang = ctext.rangeOfComposedCharacterSequences(for: subStart..<subEnd)
        let allowedText = String(ctext[crang.lowerBound..<crang.upperBound])
        text = allowedText
        sendActions(for: .editingChanged)
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: self)
    }
}

private var hasObservedEditingChangedKey = 0
private var maxTextLimitCountKey = 0

fileprivate extension UITextInput {
    var hasObservedEditingChanged: Bool {
        get {
            if let value = objc_getAssociatedObject(self, &hasObservedEditingChangedKey) as? Bool {
                return value
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &hasObservedEditingChangedKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var maxTextLimitCount: Int {
        get {
            if let value = objc_getAssociatedObject(self, &maxTextLimitCountKey) as? Int {
                return value
            }
            return Int.max
        }
        set {
            objc_setAssociatedObject(self, &maxTextLimitCountKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func private_shouldChangeCharactersWithReplacementString(_ string: String, range: NSRange, maxCount: Int, currentInputText: String, onGetTruncateString: (String) -> (), afterResetText: () -> ()) -> Bool {
        if markedTextRange != nil {
            return true
        }
        if string.isEmpty && (range.length > 0) { // 删除
            return true
        }
        if (range.location + range.length) > currentInputText.count {
            let r = NSRange(location: range.location, length: range.location + currentInputText.count)
            if r.length > 0 {
                guard (r.location + r.length) <= currentInputText.count,
                      let start = position(from: beginningOfDocument, offset: r.location),
                      let end = position(from: beginningOfDocument, offset: r.location + r.length),
                      let p = textRange(from: start, to: end) else {
                    return true
                }
                replace(p, withText: string)
            }
            return false
        }
        let currentLength = currentInputText.count
        let rangeLength = range.length
        guard currentLength - rangeLength + string.count > maxCount else {
            return true
        }
        let substringLength = maxCount - currentLength + rangeLength
        guard (substringLength > 0) && (string.count > substringLength) else {
            return false
        }
        let subRange = NSRange(location: 0, length: substringLength)
        if (subRange.location + subRange.length) > string.count {
            return false
        }
        let subStart = string.startIndex
        let subEnd = string.index(subStart, offsetBy: subRange.length)
        let crang = string.rangeOfComposedCharacterSequences(for: subStart..<subEnd)
        let allowedText = String(string[crang.lowerBound..<crang.upperBound])
        if allowedText.count <= substringLength {
            let rrstart = currentInputText.index(currentInputText.startIndex, offsetBy: range.location)
            let rrend = currentInputText.index(rrstart, offsetBy: range.length)
            let str = currentInputText.replacingCharacters(in: rrstart..<rrend, with: allowedText)
            onGetTruncateString(str)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                let nr = NSRange(location: range.location + allowedText.count, length: 0)
                if let start = self.position(from: self.beginningOfDocument, offset: nr.location),
                   let end = self.position(from: self.beginningOfDocument, offset: nr.location + nr.length),
                   let p = self.textRange(from: start, to: end) {
                    self.selectedTextRange = p
                }
            }
            afterResetText()
        }
        return false
    }
}
