//
//  WebCarouselModel.swift
//  Demo
//
//  Created by zgjff on 2022/10/3.
//

import Foundation

struct WebCarouselModel {
    let title: String
    let desc: String
    let url: URL
}

extension WebCarouselModel: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return (lhs.title == rhs.title) && (lhs.desc == rhs.desc)
    }
}
