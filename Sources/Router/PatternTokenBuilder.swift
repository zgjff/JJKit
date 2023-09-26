//
//  PatternTokenBuilder.swift
//  JJRouter
//
//  Created by zgjff on 2022/9/30.
//

import Foundation

extension JJRouter {
    internal struct PatternTokenBuilder {
        private var scanTerminals: [JJRouter.Scanner.Terminal] = []
    }
}

extension JJRouter.PatternTokenBuilder {
    /// 添加 /
    mutating func appendSlash() {
        scanTerminals.append(.slash)
    }
    
    /// 添加 ?
    mutating func appendQuery() {
        scanTerminals.append(.query)
    }
    
    /// 添加 =
    mutating func appendEqual() {
        scanTerminals.append(.equal)
    }
    
    /// 添加 &
    mutating func appendAnd() {
        scanTerminals.append(.and)
    }
    
    /// 添加 :
    mutating func appendVariable() {
        scanTerminals.append(.variable)
    }
    
    /// 添加 #
    mutating func appendFragment() {
        scanTerminals.append(.fragment)
    }
    
    /// 添加hash路由模式的url,  #/
    mutating func appendHash() {
        scanTerminals.append(.hash)
    }
    
    /// 添加 字符串
    mutating func appendLetters(_ letters: String) {
        scanTerminals.append(.letters(letters))
    }
}

extension JJRouter.PatternTokenBuilder {
    func build() -> [JJRouter.RoutingPatternToken] {
        var tokens: [JJRouter.RoutingPatternToken] = []
        for (idx, scan) in scanTerminals.enumerated() {
            switch scan {
            case .slash:
                tokens.append(.slash)
            case .query, .equal, .and, .variable, .fragment:
                continue
            case .hash:
                tokens.append(.hash)
            case .letters(let text):
                if idx == 0 {
                    tokens.append(.path(text))
                    continue
                }
                let preScan = scanTerminals[idx - 1]
                switch preScan {
                case .slash:
                    tokens.append(.path(text))
                case .query:
                    // 遵守url命名规则的?后面一般都跟查询的key
                    tokens.append(.search(key: text, value: ""))
                case .equal:
                    // 遵守url命名规则的=后面一般都跟查询的value
                    let lastToken = tokens.removeLast()
                    if case let .search(key: key, value: _) = lastToken {
                        tokens.append(.search(key: key, value: text))
                    }
                case .and:
                    // 遵守url命名规则的&后面一般都跟查询的key
                    tokens.append(.search(key: text, value: ""))
                case .fragment:
                    // 遵守url命名规则的#后面一般都跟片段,且片段字符串之后不能拼接其它数据
                    tokens.append(.fragment(value: text))
                case .variable:
                    // 这个一般是存储变量的
                    tokens.append(.variable(key: text))
                case .letters:
                    // 这个永远不会出现
                    continue
                case .hash:
                    tokens.append(.path(text))
                }
            }
        }
        return tokens
    }
}
