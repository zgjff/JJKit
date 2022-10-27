//
//  ViewController.swift
//  Demo
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

class ViewController: UIViewController {
    private lazy var tableView = UITableView()
    private var datas: [(title: String, action: String)] = []
}

extension ViewController {
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
private extension ViewController {
    @IBAction func showRouterDemos() {
        openDemoRouter(.jjrouter)
    }
    
    @IBAction func showCarouselDemos() {
        openDemoRouter(.carousel)
    }
    
    @IBAction func showExtensionDemos() {
        openDemoRouter(.extensions)
    }
    
    @IBAction func showTestIdeas() {
        openDemoRouter(.test)
    }
    
    private func openDemoRouter(_ router: DemoRouter) {
        do {
            let result = try JJRouter.open(router)
            result.jump(from: self)
        } catch {
            print("open Router demos failure: ", error)
        }
    }
}

private extension ViewController {
    func setup() {
        title = "Root"
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .black
        }
        datas = [
            ("路由", "showRouterDemos"),
            ("轮播图", "showCarouselDemos"),
            ("Extensions", "showExtensionDemos"),
            ("Idea", "showTestIdeas")
        ]
        tableView.delegate = self
        tableView.dataSource = self
    }
}
