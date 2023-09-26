//
//  EventBusDemoController.swift
//  Demo
//
//  Created by zgjff on 2023/9/22.
//

import UIKit

/// eventbus demo
class EventBusDemoController: UIViewController {
    private lazy var bag = JJEventDisposeBag()
    private var bEventDispose: JJEventDispose?
    deinit {
        print("EventBusDemoController  deinit")
    }
}

extension EventBusDemoController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        let navi = UINavigationController(rootViewController: self)
        navi.modalPresentationStyle = .fullScreen
        sourceController.present(navi, animated: true)
    }
}

extension EventBusDemoController: AddCloseNaviItemToDismissable {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "EventBus"
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .black
        }
        addCloseNaviItem()
        
        let b = UIButton()
        b.backgroundColor = .jRandom()
        b.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        b.center = view.center
        view.addSubview(b)
        b.jj.handler({ _ in
            DispatchQueue.global().async {
                JJEventBus.default.post(identifier: "sendMessage", context: ["a": 1, "b": "name", "c": [1, 2, 3]])
            }
        }, for: .primaryActionTriggered)
        
        let c = UIButton()
        c.backgroundColor = .jRandom()
        c.frame = b.frame.offsetBy(dx: 0, dy: 80)
        view.addSubview(c)
        c.jj.handler({ [unowned self] _ in
            self.bag = JJEventDisposeBag()
        }, for: .primaryActionTriggered)
        
        JJEventBus.default.addObserver(self, identifier: "sendMessage").subscribe(onNext: { event in
            print("sendMessage--------a: ", Thread.current, event)
        }).dispose(by: bag)
        
        bEventDispose = JJEventBus.default.addObserver(self, identifier: "sendMessage").observeOn(queue: OperationQueue()).subscribe(onNext: { event in
            print("sendMessage--------b: ", Thread.current, event)
        })
        
        JJEventBus.default.addObserver(self, identifier: "sendMessage").observeOn(queue: .main).subscribe(onNext: { event in
            print("sendMessage--------c: ", Thread.current, event)
        }).dispose(by: bag)
    }
}
