//
//  ToastDemosController.swift
//  Demo
//
//  Created by zgjff on 2023/8/8.
//

import UIKit
private let cellIdentifier = "cell"
/// taost demo
class ToastDemosController: UIViewController {
    private lazy var tableView = UITableView()
    private var actions: [RootRowAction] = []
}

extension ToastDemosController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        let navi = UINavigationController(rootViewController: self)
        navi.modalPresentationStyle = .fullScreen
        sourceController.present(navi, animated: true)
    }
}

extension ToastDemosController: AddCloseNaviItemToDismissable {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Toast"
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .black
        }
        addCloseNaviItem()
        tableView.frame = view.bounds
        view.addSubview(tableView)
        configDatas()
        tableView.rowHeight = 50
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ToastDemosController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        actions.count
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

private extension ToastDemosController {
    func configDatas() {
        actions = [
            RootRowAction(title: "文字居中", action: "showTextAtCenter")
        ]
    }
}

private extension ToastDemosController {
    @IBAction func showTextAtCenter() {
        view.makeToast(JJTextToastItem(text: "居中文字"))
            .onTap(block: { toast in
                toast.beginHidden(animated: true)
            })
            .duration(.distantFuture)
            .show(animated: true)
    }
}
