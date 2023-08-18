//
//  UIView+TransferResponder.swift
//  JJKit
//
//  Created by zgjff on 2023/8/17.
//

import UIKit

extension UIResponder: JJCompatible {}

public extension JJBox where Base: UIResponder {
    /// 事件跨层传递
    ///
    /// 一般用于将UIView事件跨层传递给其它View或者ViewController. 注意,此方法是通过响应者链去检查并处理的,并不能用于不同的响应者链。
    ///
    /// 例如: 某个页面比较复杂,层级较多: controller->A->B->C->D, 如果是D上面的按钮的点击事件, 一般是通过`block`或者`delegate`通过D->C->B->A->Controller,
    /// 一层一层的传递,将事件抛出到控制器去处理, 链路很长,很麻烦,代码也不好维护。
    ///
    /// 本方案就是为了解决这个问题的。
    ///
    /// 使用方法:
    ///
    /// 1: 先定义一个协议(代理)
    ///
    ///     protocol DealDViewActionable {
    ///         func onTapButton()
    ///     }
    ///
    /// 2: 在需要处理点击逻辑的地方遵守并实现对应的协议(代理): 如控制器
    ///
    ///     extension ViewController: DealDViewActionable {
    ///         func onTapButton() {
    ///             print("ViewController----onTapButton")
    ///         }
    ///      }
    ///
    /// 3: 在按钮的点击事件内部调用本方法即可.
    ///
    ///     @IBAction private func onClick(_ sender: UIButton) {
    ///        self.jj.transfer { rel in
    ///            if let rels = rel as? DealDViewActionable {
    ///                rels.onTapButton()
    ///                return true
    ///            }
    ///            return false
    ///        }
    ///    }
    ///
    /// 4: 如果不想在最上层的控制器处理此事件,而在其中一个响应者链处理,只需要让其遵守并实现对应的协议(代理)。如想在B做处理,只需要B遵守`DealDViewActionable`协议即可
    ///
    /// - Parameter handler: 检查并执行
    func transfer(checkAndExecute handler: (_ responder: UIResponder) -> Bool) {
        var nextRespnder: UIResponder? = base
        while nextRespnder != nil {
            if let nr = nextRespnder, handler(nr) {
                return
            }
            nextRespnder = nextRespnder?.next
        }
    }
}
