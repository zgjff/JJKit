//
//  PassParameterRouter.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import Foundation

enum PassParameterRouter {
    case byEnum(p: String, q: Int)
    case byUrl
    case byUrlWithQuery
    case byContext
    case mixUrlAndContext
    case parameterForInit
    case updateUIMatchedSame
}

extension PassParameterRouter {
    static func register() {
        let registers: [PassParameterRouter] = [.byEnum(p: "", q: 0), .byUrl, .byUrlWithQuery, .byContext, .mixUrlAndContext, .parameterForInit, .updateUIMatchedSame]
        registers.forEach { try! $0.register() }
    }
}

extension PassParameterRouter: JJRouterSource {
    var routerPattern: String {
        switch self {
        case .byEnum: return "/app/passParameterByEnum/:p/:q"
        case .byUrl: return "/app/passParameterByUrl/:pid/:name"
        case .byUrlWithQuery: return "/app/search"
        case .byContext: return "/app/passParameterByContext"
        case .mixUrlAndContext: return "/app/mixUrlAndContext/:pid/:text"
        case .parameterForInit: return "/app/parameterForInit/:id"
        case .updateUIMatchedSame: return "/app/updateUIMatchedSame/:id"
        }
    }
    
    var routerParameters: [String: String] {
        switch self {
        case .byUrl, .byUrlWithQuery, .byContext, .mixUrlAndContext, .parameterForInit, .updateUIMatchedSame:
            return [:]
        case let .byEnum(p: p, q: q):
            return ["p": p, "q": "\(q)"]
        }
    }
    
    func makeRouterDestination(parameters: [String : String], context: Any?) -> JJRouterDestination {
        switch self {
        case .byEnum:
            let p = parameters["p"] ?? ""
            let qstr = parameters["q"] ?? ""
            let numberFormatter = NumberFormatter()
            let q = numberFormatter.number(from: qstr)?.intValue
            return PassParameterByEnumController(p: p, q: q ?? 0)
        case .byUrl:
            return PassParameterByUrlController()
        case .byUrlWithQuery:
            return PassParameterByUrlWithQueryController()
        case .byContext:
            return PassParameterByContextController()
        case .mixUrlAndContext:
            return PassParameterMixUrlAndContextController()
        case .parameterForInit:
            let idstr = parameters["id"] ?? ""
            let numberFormatter = NumberFormatter()
            let id = numberFormatter.number(from: idstr)?.intValue
            return PassParametersForInitController(id: id ?? 0)
        case .updateUIMatchedSame:
            return UpdateUIWhenMatchSameController()
        }
    }
}
