//
//  RouterDestination.swift
//  JJRouter
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

/// 匹配成功后的路由目标界面协议
public protocol JJRouterDestination {
    /// 当匹配到的路由跟当前展示的界面相同时的操作方法,默认返回`new`
    ///
    /// 返回`none`时,不做任何操作
    ///
    /// 返回`update`时,会调用`updateWhenRouterIdentifierIsSame`方法来更新当前界面
    ///
    /// 返回`new`时,会调用`showDetail`来重新展示新的界面
    /// - Parameter result: 匹配结果
    func actionWhenMatchedRouterDestinationSameToCurrent(withNewMatchRouterResult result: JJRouter.MatchResult) -> JJRouter.MatchedSameRouterDestinationAction
    
    /// 当当前界面为路由匹配到的界面时,并且当前控制器跟匹配到的控制器一致时的操作
    func updateWhenRouterIdentifierIsSame(withNewMatchRouterResult result: JJRouter.MatchResult)
    
    /// 显示匹配到的界面逻辑
    ///
    /// 默认实现是如果有导航栏则push,否则present
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController)
}

extension JJRouterDestination {
    public func actionWhenMatchedRouterDestinationSameToCurrent(withNewMatchRouterResult result: JJRouter.MatchResult) -> JJRouter.MatchedSameRouterDestinationAction {
        return .new
    }
    
    public func updateWhenRouterIdentifierIsSame(withNewMatchRouterResult result: JJRouter.MatchResult) {}
    
    /// 处理路由匹配到的界面
    /// - Parameter result: 匹配结果
    func deal(withMatchedResult result: JJRouter.MatchResult, from sourceController: UIViewController?) {
        let fromController = sourceController ?? JJRouter.default.apptopController(JJRouter.default.appKeyWindow()?.rootViewController)
        guard let tvc = fromController else {
            return
        }
        if type(of: tvc) != type(of: self) {
            return showDetail(withMatchRouterResult: result, from: tvc)
        }
        guard let sameVC = tvc as? JJRouterDestination else {
            showDetail(withMatchRouterResult: result, from: tvc)
            return
        }
        switch sameVC.actionWhenMatchedRouterDestinationSameToCurrent(withNewMatchRouterResult: result) {
        case .none:
            return
        case .update:
            sameVC.updateWhenRouterIdentifierIsSame(withNewMatchRouterResult: result)
        case .new:
            showDetail(withMatchRouterResult: result, from: tvc)
        }
    }
}

extension JJRouterDestination where Self: UIViewController {
    public func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        if let navi = sourceController.navigationController {
            navi.pushViewController(self, animated: true)
            return
        }
        sourceController.present(self, animated: true)
    }
}
