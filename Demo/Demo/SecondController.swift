//
//  SecondController.swift
//  Demo
//
//  Created by 郑桂杰 on 2019/7/30.
//  Copyright © 2019 郑桂杰. All rights reserved.
//

import UIKit

class SecondController: UIViewController {
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
        v.jj.bind { make in
            make.didScroll({ sc in
                print(sc.contentOffset.y)
            })
            make.cellForRow({ tb, ip  in
                let cell = tb.dequeueReusableCell()
                cell.textLabel?.text = "\(ip.section)---\(ip.row)"
                return cell
            }).numberOfRows({ _, _ in
                return 100
            }).heightForRow({ _, ip in
                return ip.row < 50 ? 44 : 64
            })
        }
    }
}
