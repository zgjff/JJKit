//
//  RouterDemosController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

private let cellIdentifier = "cell"
class RouterDemosController: UIViewController {
    private lazy var tableView = UITableView()
    private var actions: [RootRowAction] = []
}

extension RouterDemosController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        let navi = UINavigationController(rootViewController: self)
        navi.modalPresentationStyle = .fullScreen
        sourceController.present(navi, animated: true)
    }
}

extension RouterDemosController: AddCloseNaviItemToDismissable {
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "路由Demo"
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .black
        }
        addCloseNaviItem()
        configDatas()
        tableView.rowHeight = 50
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension RouterDemosController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if #available(iOS 14.0, *) {
            var configuration = cell.defaultContentConfiguration()
            configuration.text = actions[indexPath.row].title
            cell.contentConfiguration = configuration
        } else {
            cell.textLabel?.text = actions[indexPath.row].title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let str = actions[indexPath.row].action
        if str.isEmpty {
            return
        }
        let sel = Selector(str)
        perform(sel)
    }
}

private extension RouterDemosController {
    func configDatas() {
        actions = [
            RootRowAction(title: "Push With Eunm", action: "onClickPushUsingEnum"),
            RootRowAction(title: "Push With Path", action: "onClickPushUsingPath"),
            RootRowAction(title: "Push With Url", action: "onClickPushUsingUrl"),
            RootRowAction(title: "Present", action: "onClickPresent"),
            RootRowAction(title: "PushPop Style Present", action: "onClickPushPopStylePresent"),
            RootRowAction(title: "Center Alert ", action: "onClickAlertCenter"),
            RootRowAction(title: "block 1 ", action: "onClickBackBlock"),
            RootRowAction(title: "block 2 ", action: "onClickFrontBlock"),
            RootRowAction(title: "map block ", action: "onClickMapBlock"),
            RootRowAction(title: "pass parameter By url", action: "onClickPassParameterByUrl"),
            RootRowAction(title: "pass parameter By url with query", action: "onClickPassParameterByUrlWithQuery"),
            RootRowAction(title: "pass parameter By context", action: "onClickPassParameterByContext"),
            RootRowAction(title: "pass parameter By url and context", action: "onClickPassParameterMixUrlAndContext"),
            RootRowAction(title: "pass parameter for controller init", action: "onClickHandleParameterForInit"),
            RootRowAction(title: "pass parameter By enum", action: "onClickPassParameterByEnum"),
            RootRowAction(title: "update ui when match same route", action: "onClickUpdateUIWhenMatchSameController"),
        ]
    }
}

// MARK: - Simple
private extension RouterDemosController {
    @IBAction func onClickPushUsingEnum() {
        (try? JJRouter.default.open(SimpleRouter.systemPush))?.jump(from: self)
    }
    
    @IBAction func onClickPushUsingPath() {
        (try? JJRouter.default.open("/app/systemPush"))?.jump(from: self)
    }
    
    @IBAction func onClickPushUsingUrl() {
        if let url = URL(string: "https://www.appwebsite.com/app/systemPush/") {
            (try? JJRouter.default.open(url))?.jump(from: self)
        }
    }
    
    @IBAction func onClickPresent() {
        (try? JJRouter.default.open(SimpleRouter.systemPresent))?.jump(from: nil)
    }
    
    @IBAction func onClickPushPopStylePresent() {
        (try? JJRouter.default.open(SimpleRouter.pushPopStylePreset))?.jump(from: self)
    }
    
    @IBAction func onClickAlertCenter() {
        (try? JJRouter.default.open(SimpleRouter.alertCenter))?.jump(from: self)
    }
}

// MARK: - block回调
private extension RouterDemosController {
    // 正常block回调: A跳转B, B通过路由block将数据回调给A
    @IBAction func onClickBackBlock() {
        // 不缩写的代码逻辑应该是这样的
        let result = try? JJRouter.default.open(BlockRouter.backBlock)
        let router = result?.jump(from: self)
        // 当然也可以缩写
//        let router = (try? JJRouter.default.open(BlockRouter.backBlock))?.jump(from: self)
        router?.register(blockName: "onSend", callback: { obj in
            print("get data: \(obj) from router block")
        })
    }
    
    // 非正常block回调
    // A跳转B, A通过路由block将实时数据回调给B
    @IBAction func onClickFrontBlock() {
        (try? JJRouter.default.open(BlockRouter.frontBlockA))?.jump(from: self)
    }
    
    // 非正常block回调
    // A需要跳转B,但是条件达不到,需要跳转到其它路由界面C,此时可以正常拿到C的回调
    @IBAction func onClickMapBlock() {
        let router = (try? JJRouter.default.open(BlockRouter.mapBlock))?.jump(from: self)
        router?.register(blockName: "loginSuccess", callback: { _ in
            print("登录成功")
        })
    }
}

// MARK: - 传参数
private extension RouterDemosController {
    @IBAction func onClickPassParameterByUrl() {
        (try? JJRouter.default.open("/app/passParameterByUrl/album_tab12.9abc/jack"))?.jump(from: self)
    }
    
    @IBAction func onClickPassParameterByUrlWithQuery() {
        (try? JJRouter.default.open("/app/search?name=lili&age=18"))?.jump(from: self)
    }
    
    @IBAction func onClickPassParameterByContext() {
        (try? JJRouter.default.open(PassParameterRouter.byContext, context: 12))?.jump(from: self)
    }
    
    @IBAction func onClickPassParameterMixUrlAndContext() {
        (try? JJRouter.default.open("/app/mixUrlAndContext/12/keke", context: arc4random_uniform(2) == 0))?.jump(from: self)
    }
    
    @IBAction func onClickHandleParameterForInit() {
        (try? JJRouter.default.open("/app/parameterForInit/66"))?.jump(from: self)
    }
    
    @IBAction func onClickPassParameterByEnum() {
        (try? JJRouter.default.open(PassParameterRouter.byEnum(p: "entry", q: 108)))?.jump(from: self)
    }
    
    @IBAction func onClickUpdateUIWhenMatchSameController() {
        (try? JJRouter.default.open("/app/updateUIMatchedSame/18"))?.jump(from: self)
    }
}
