//
//  ExtensionDemosController.swift
//  Demo
//
//  Created by zgjff on 2022/10/8.
//

import UIKit

class ExtensionDemosController: UIViewController {
    private lazy var tableView = UITableView()
    private var datas: [(title: String, action: String)] = []
}

extension ExtensionDemosController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        let navi = UINavigationController(rootViewController: self)
        navi.modalPresentationStyle = .fullScreen
        sourceController.present(navi, animated: true)
    }
}

extension ExtensionDemosController: AddCloseNaviItemToDismissable {
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ExtensionDemosController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.jj.dequeueReusableCell()
        let data = datas[indexPath.row]
        if #available(iOS 14.0, *) {
            var config = cell.defaultContentConfiguration()
            config.text = data.title
            cell.contentConfiguration = config
        } else {
            cell.textLabel?.text = data.title
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = datas[indexPath.row]
        let sel = Selector(data.action)
        perform(sel)
    }
}

//MARK: - cell actions
private extension ExtensionDemosController {
    @IBAction func showAttributeDemos() {
        openDemoRouter(.attribute)
    }
    
    @IBAction func showRenderImageDemos() {
        openDemoRouter(.renderImage)
    }
    
    private func openDemoRouter(_ router: ExtensionRouter) {
        do {
            let result = try JJRouter.open(router)
            result.jump(from: self)
        } catch {
            print("open Router demos failure: ", error)
        }
    }
}

private extension ExtensionDemosController {
    func setup() {
        title = "Extensions"
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .black
        }
        addCloseNaviItem()
        datas = [
            ("富文本", "showAttributeDemos"),
            ("图片", "showRenderImageDemos"),
        ]
        tableView.delegate = self
        tableView.dataSource = self
    }
}
