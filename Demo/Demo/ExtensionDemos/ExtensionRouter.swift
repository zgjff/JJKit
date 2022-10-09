//
//  ExtensionRouter.swift
//  Demo
//
//  Created by zgjff on 2022/10/8.
//

import UIKit

enum ExtensionRouter: String, CaseIterable {
    case attribute = "/app/attribute"
    case renderImage = "/app/renderImage"
}

extension ExtensionRouter: JJRouterSource {
    var routerPattern: String {
        return rawValue
    }

    func makeRouterDestination(parameters: [String : String], context: Any?) -> JJRouterDestination {
        switch self {
        case .attribute:
            return AttributMakerDemoController()
        case .renderImage:
            return UIImageRenderController()
        }
    }
}

