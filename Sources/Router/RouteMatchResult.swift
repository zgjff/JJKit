//
//  RouteMatchResult.swift
//  JJKit
//
//  Created by 郑桂杰 on 2022/9/30.
//

import Foundation

struct RouteMatchResult {
    let pattern: String
    let url: URL
    let parameters: [String: String]
}
