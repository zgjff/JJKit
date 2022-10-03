//
//  SimpleRouter.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import Foundation
import UIKit

enum SimpleRouter: String, CaseIterable {
    case systemPush = "/app/systemPush"
    case systemPresent = "/app/systemPresent"
    case pushPopStylePreset = "/app/pushPopStylePreset"
    case alertCenter = "/app/alertCenter"
    case web = "/app/web"
    case login = "/app/login"
}

extension SimpleRouter: JJRouterSource {
    var routerPattern: String {
        return rawValue
    }

    func makeRouterDestination(parameters: [String : String], context: Any?) -> JJRouterDestination {
        switch self {
        case .systemPush:
            return SystemPushController()
        case .systemPresent:
            return SystemPresentController()
        case .pushPopStylePreset:
            return PushStylePresentController()
        case .alertCenter:
            return AlertCenterController()
        case .web:
            return AlertCenterController()
        case .login:
            return LoginController()
        }
    }
}
