//
//  DemoRouter.swift
//  Demo
//
//  Created by zgjff on 2022/10/8.
//

import UIKit

enum DemoRouter: String, CaseIterable {
    case jjrouter = "/app/jjrouter"
    case carousel = "/app/jjcarousel"
    case extensions = "/app/extensions"
    case toast       = "/app/toast"
    case test        = "/app/test"
}

extension DemoRouter: JJRouterSource {
    var routerPattern: String {
        return rawValue
    }

    func makeRouterDestination(parameters: [String : String], context: Any?) -> JJRouterDestination {
        switch self {
        case .jjrouter:
            return RouterDemosController()
        case .carousel:
            return CarouselTabbarController()
        case .extensions:
            return ExtensionDemosController()
        case .toast:
            return ToastDemosController()
        case .test:
            return IdeaController()
        }
    }
}
