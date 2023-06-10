//
//  RubyAnnotation.swift
//  JJKit
//
//  Created by zgjff on 2023/4/16.
//

import UIKit
import CoreText

extension YJText {
    public struct RubyAnnotation {
        public var alignment = CTRubyAlignment.auto
        
        public var overhang = CTRubyOverhang.auto
        
        public var sizeFactor: CGFloat = 0.5
        
        public var textBefore: String?
        
        public var textAfter: String?
        
        public var textInterCharacter: String?
        
        public var textInline: String?
        
        
        public init(alignment: CTRubyAlignment = CTRubyAlignment.auto, overhang: CTRubyOverhang = CTRubyOverhang.auto, sizeFactor: CGFloat = 0.5, textBefore: String? = nil, textAfter: String? = nil, textInterCharacter: String? = nil, textInline: String? = nil) {
            self.alignment = alignment
            self.overhang = overhang
            self.sizeFactor = sizeFactor
            self.textBefore = textBefore
            self.textAfter = textAfter
            self.textInterCharacter = textInterCharacter
            self.textInline = textInline
        }
        
        public init(rubyAnnotation: CTRubyAnnotation) {
            alignment = CTRubyAnnotationGetAlignment(rubyAnnotation)
            overhang = CTRubyAnnotationGetOverhang(rubyAnnotation)
            sizeFactor = CTRubyAnnotationGetSizeFactor(rubyAnnotation)
            if let text = CTRubyAnnotationGetTextForPosition(rubyAnnotation, .before) {
                textBefore = text as String
            } else {
                textBefore = nil
            }
            if let text = CTRubyAnnotationGetTextForPosition(rubyAnnotation, .after) {
                textAfter = text as String
            } else {
                textAfter = nil
            }
            if let text = CTRubyAnnotationGetTextForPosition(rubyAnnotation, .interCharacter) {
                textInterCharacter = text as String
            } else {
                textInterCharacter = nil
            }
            if let text = CTRubyAnnotationGetTextForPosition(rubyAnnotation, .inline) {
                textInline = text as String
            } else {
                textInline = nil
            }
        }
    }
}

extension YJText.RubyAnnotation {
    public var ctRubyAnnotation: CTRubyAnnotation {
        let text = UnsafeMutablePointer<Unmanaged<CFString>?>.allocate(capacity: Int(CTRubyPosition.count.rawValue))
        defer {
            text.deallocate()
        }
        func replace_text(position: CTRubyPosition, with string: String?) {
            let idx = Int(CTRubyPosition.before.rawValue)
            if let string {
                text[idx] = Unmanaged.passUnretained(string as CFString)
            } else {
                text[idx] = .none
            }
        }
        replace_text(position: .before, with: textBefore)
        replace_text(position: .after, with: textAfter)
        replace_text(position: .interCharacter, with: textInterCharacter)
        replace_text(position: .inline, with: textInline)
        return CTRubyAnnotationCreate(alignment, overhang, sizeFactor, text)
    }
}

extension YJText.RubyAnnotation: Codable {
    private enum RubyAnnotationCodingKey: String, CodingKey {
        case alignment, overhang, sizeFactor
        case textBefore, textAfter, textInterCharacter, textInline
    }
    
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: RubyAnnotationCodingKey.self)
        let alignmentUInt8 = try c.decode(UInt8.self, forKey: .alignment)
        alignment = CTRubyAlignment(rawValue: alignmentUInt8) ?? .auto
        let overhangUInt8 = try c.decode(UInt8.self, forKey: .overhang)
        overhang = CTRubyOverhang(rawValue: overhangUInt8) ?? .auto
        sizeFactor = try c.decode(CGFloat.self, forKey: .sizeFactor)
        textBefore = try? c.decodeIfPresent(String.self, forKey: .textBefore)
        textAfter = try? c.decodeIfPresent(String.self, forKey: .textAfter)
        textInterCharacter = try? c.decodeIfPresent(String.self, forKey: .textInterCharacter)
        textInline = try? c.decodeIfPresent(String.self, forKey: .textInline)
    }
    
    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: RubyAnnotationCodingKey.self)
        try c.encode(alignment.rawValue, forKey: .alignment)
        try c.encode(overhang.rawValue, forKey: .overhang)
        try c.encode(sizeFactor, forKey: .sizeFactor)
        if let textBefore {
            try c.encode(textBefore, forKey: .textBefore)
        }
        if let textAfter {
            try c.encode(textAfter, forKey: .textAfter)
        }
        if let textInterCharacter {
            try c.encode(textInterCharacter, forKey: .textInterCharacter)
        }
        if let textInline {
            try c.encode(textInline, forKey: .textInline)
        }
    }
}
