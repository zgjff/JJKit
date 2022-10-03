//
//  FrontBlockAController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class FrontBlockAController: UIViewController, ShowMatchRouterable {
    private var result: JJRouter.MatchResult?
    private var timer: Timer?
    private var data = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "A"
        view.backgroundColor = .jRandom()
        let b = UIButton()
        b.backgroundColor = .jRandom()
        b.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 160, height: 44)
        b.center = view.center
        b.addTarget(self, action: #selector(onClick), for: .primaryActionTriggered)
        view.addSubview(b)
        if #available(iOS 10.0, *) {
            timer = Timer(timeInterval: 2, repeats: true, block: { [weak self] _ in
                if let self = self {
                    self.data += 12
                    self.title = "A: \(self.data)"
                }
            })
        } else {
            timer = Timer(timeInterval: 2, target: self, selector: #selector(repeatTimer), userInfo: nil, repeats: true)
        }
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .common)
            timer.fire()
        }
        showMatchResult(result)
    }
    
    @IBAction private func onClick() {
        // A跳转B, A通过路由block将实时数据回调给B
        // 主要用于,A的数据是实时变化的,B需要拿到A的最新数据
        let router = (try? JJRouter.default.open(BlockRouter.frontBlockB))?.jump(from: self)
        router?.register(blockName: "onNeedGetNewestData", callback: { [weak self] obj in
            guard let self = self,
                let block = obj as? (Int) -> () else {
                return
            }
            block(self.data)
        })
    }
    
    @IBAction private func repeatTimer() {
        data += 12
        title = "A: \(data)"
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}

extension FrontBlockAController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        let navi = UINavigationController(rootViewController: self)
        sourceController.present(navi, animated: true)
    }
}
