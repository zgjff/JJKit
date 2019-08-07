//
//  SecondController.swift
//  Demo
//
//  Created by 郑桂杰 on 2019/7/30.
//  Copyright © 2019 郑桂杰. All rights reserved.
//

import UIKit

class SecondController: UIViewController {
    private lazy var viewModel = ViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        let v = UITableView()
        v.jj.layout { make in
            make.width.equalTo(view).offsetBy(-50)
            make.center.equalTo(view)
            make.height.equalTo(view).offsetBy(-150)
        }
        v.contentSize = CGSize(width: v.jj.width, height: v.jj.height * 2)
        v.backgroundColor = .orange
        view.addSubview(v)
        v.jj.bind {make in
            make.cellForRow({ tb, ip  in
                let cell = tb.dequeueReusableCell()
                cell.textLabel?.text = "\(ip.section)---\(ip.row)"
                return cell
            })
            make.numberOfSections(viewModel.numberOfSections)
            make.numberOfRows({ _, _ -> Int in
                return 100
            })
        }
    }
}
