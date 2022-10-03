//
//  BlockRouter.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import Foundation

enum BlockRouter: String, CaseIterable {
    case backBlock = "/app/backBlock"
    case frontBlockA = "/app/frontBlockA"
    case frontBlockB = "/app/frontBlockB"
    case mapBlock  = "/app/mapBlock"
}

extension BlockRouter: JJRouterSource {
    var routerPattern: String {
        return rawValue
    }
    
    func register() throws {
        try JJRouter.default.register(pattern: routerPattern, mapRouter: { matchResult in
            guard case .mapBlock = self else {
                return self
            }
            let needGotoLoginController = arc4random_uniform(2) == 0
            if needGotoLoginController {
                return SimpleRouter.login
            }
            return self
        })
    }
    
    func makeRouterDestination(parameters: [String : String], context: Any?) -> JJRouterDestination {
        switch self {
        case .backBlock:
            return BackBlockController()
        case .frontBlockA:
            return FrontBlockAController()
        case .frontBlockB:
            return FrontBlockBController()
        case .mapBlock:
            return MapBlockController()
        }
    }
}
