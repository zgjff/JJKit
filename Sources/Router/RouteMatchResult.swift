//
//  RouteMatchResult.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import Foundation

struct RouteMatchResult {
    let pattern: String
    let url: URL
    let parameters: [String: String]
}
