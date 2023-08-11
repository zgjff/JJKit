//
//  ToastDemosController.swift
//  Demo
//
//  Created by zgjff on 2023/8/8.
//

import UIKit
import SDWebImage
private let cellIdentifier = "cell"
/// taost demo
class ToastDemosController: UIViewController {
    private lazy var tableView = UITableView()
    private var actions: [RootRowAction] = []
    
    deinit {
        print("ToastDemosController  deinit")
    }
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
            RootRowAction(title: "文字居中", action: "showTextAtCenter"),
            RootRowAction(title: "富文本顶部安全区域显示", action: "showAttrTextAtSafeTop"),
            RootRowAction(title: "显示系统的指示器", action: "showSystemActivityIndicatorAtCenter"),
            RootRowAction(title: "显示三色转动的的指示器", action: "showArcrotationIndicatorAtCenter"),
            RootRowAction(title: "显示本地图片", action: "showSingleImageAtSafeBottom"),
            RootRowAction(title: "在3/4处显示多个图片动画", action: "showMultipleImagesAtThreeQuarter"),
            RootRowAction(title: "显示网络图片", action: "showWebImage"),
            RootRowAction(title: "使用SDAnimatedImageView显示gif图片", action: "showSDGifImage"),
            RootRowAction(title: "使用带有色彩的容器来显示toast", action: "showUsingColorContainerTextToast"),
            RootRowAction(title: "使用渐变色的容器来显示toast", action: "showUsingGradientContainerTextToast"),
            RootRowAction(title: "混合文字+文字的toast", action: "showMixTextAndTextToast"),
            RootRowAction(title: "混合指示器+文字的toast", action: "showMixActivityAndTextToast"),
            RootRowAction(title: "左右展示混合三色转动指示器+文字的toast", action: "showMixArcrotationAndTextToast"),
            RootRowAction(title: "左右展示混合三色转动指示器+指示器的toast", action: "showMixArcrotationAndActivityToast"),
            RootRowAction(title: "上下展示混合文字+网络图片的toast", action: "showMixTextAndWebImageToast"),
            RootRowAction(title: "自定义展示动画的toast", action: "showCustomAppearAniamtorToast"),
            RootRowAction(title: "自定义消失动画的toast", action: "showCustomDisappearAniamtorToast"),
        ]
    }
}

private extension ToastDemosController {
    @IBAction func showTextAtCenter() {
        view.makeToast(JJTextToastItem(text: "居中文字"))
            .didTap(block: { toast in
                toast.dismiss(animated: true)
            })
            .show(animated: true)
    }
    
    @IBAction func showAttrTextAtSafeTop() {
        let str = "从安全区域顶部显示\n我是一个富文本toast,你可以方便的使用"
        let att = NSMutableAttributedString(string: str)
        let r = (str as NSString).range(of: "富文本")
        att.addAttributes([.font: UIFont.boldSystemFont(ofSize: 25), .foregroundColor: UIColor.orange], range: r)
        let r1 = (str as NSString).range(of: "从安全区域顶部显示")
        att.addAttributes([.font: UIFont.boldSystemFont(ofSize: 13), .foregroundColor: UIColor.cyan], range: r1)
        view.makeToast(JJTextToastItem(attributedString: att))
            .position(.safeTop)
            .show()
    }
    
    @IBAction func showSystemActivityIndicatorAtCenter() {
        view.makeToast(JJActivityToastItem())
            .autoDismissOnTap()
            .show(animated: true)
    }
    
    @IBAction func showArcrotationIndicatorAtCenter() {
        view.makeToast(JJArcrotationToastItem())
            .autoDismissOnTap()
            .duration(.distantFuture)
            .show(animated: true)
    }
    
    @IBAction func showSingleImageAtSafeBottom() {
        if #available(iOS 13.0, *) {
            let img = UIImage(systemName: "mic")!
            view.makeToast(JJImageToastItem(image: img))
                .position(.safeBottom)
                .show()
        }
    }
    
    @IBAction func showMultipleImagesAtThreeQuarter() {
        if #available(iOS 13.0, *) {
            let img1 = UIImage(systemName: "mic")!
            let img2 = UIImage(systemName: "mic.fill")!
            let img3 = UIImage(systemName: "mic.circle")!
            let img4 = UIImage(systemName: "mic.circle.fill")!
            let img = UIImage.animatedImage(with: [img1.withTintColor(.orange), img2, img3, img4], duration: 2)!
            view.makeToast(JJImageToastItem(image: img))
                .duration(.distantFuture)
                .position(.threeQuarter)
                .autoDismissOnTap()
                .show()
        }
    }
    
    @IBAction func showWebImage() {
        guard let url = URL(string: "http://apng.onevcat.com/assets/elephant.png") else {
            return
        }
        view.makeToast(JJImageToastItem(url: url, display: { url, imageView in
            imageView.sd_setImage(with: url, completed: nil)
        })).updateItem(options: { opt in
            opt.imageSize = .fixed(CGSize(width: 150, height: 150))
            opt.configUIImageView = { iv in
                iv.contentMode = .scaleAspectFill
                iv.clipsToBounds = true
            }
        })
        .autoDismissOnTap()
        .duration(.distantFuture)
        .position(.center).show()
    }
    
    @IBAction func showSDGifImage() {
        guard let url = URL(string: "http://assets.sbnation.com/assets/2512203/dogflops.gif") else {
            return
        }
        view.makeToast(JJImageToastItem(data: .web(url: url, display: { url, _ in
            let animatedView = SDAnimatedImageView()
            animatedView.sd_setImage(with: url, completed: nil)
            return animatedView
        }))).updateItem(options: { opt in
            opt.imageSize = .fixed(CGSize(width: 150, height: 150))
            opt.margin = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        })
        .duration(.distantFuture)
        .position(.threeQuarter)
        .autoDismissOnTap()
        .show()
    }
    
    @IBAction func showUsingColorContainerTextToast() {
        view.makeToast(JJTextToastItem(text: "我是一个带色彩背景的toast"))
            .useContainer(JJColorfulContainer(color: .jRandom()))
            .duration(.distantFuture)
            .autoDismissOnTap()
            .show()
    }
    
    @IBAction func showUsingGradientContainerTextToast() {
        view.makeToast(JJTextToastItem(text: "我是一个带渐变色背景的toast"))
            .useContainer(JJGradientContainer(colors: [.jRandom(), .jRandom(), .jRandom()]))
            .position(.threeQuarter)
            .duration(.distantFuture)
            .autoDismissOnTap()
            .show()
    }
    
    @IBAction func showMixTextAndTextToast() {
        view.makeToast(JJMixTwoToastItem(first: JJTextToastItem(attributedString: NSAttributedString(string: "标题", attributes: [.font: UIFont.systemFont(ofSize: 22), .foregroundColor: UIColor.jRandom()])), second: JJTextToastItem(text: "我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容")))
            .duration(.distantFuture)
            .autoDismissOnTap()
            .show()
    }
    
    @IBAction func showMixActivityAndTextToast() {
        view.makeToast(JJMixTwoToastItem(first: JJActivityToastItem(), second: JJTextToastItem(text: "我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容")))
            .duration(.distantFuture)
            .autoDismissOnTap()
            .show()
    }
    
    @IBAction func showMixArcrotationAndTextToast() {
        view.makeToast(JJMixTwoToastItem(first: JJArcrotationToastItem(), second: JJTextToastItem(text: "我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容我是内容")))
            .updateItem(options: { options in
                options.layout = .ltr_center
            })
            .duration(.distantFuture)
            .autoDismissOnTap()
            .show()
    }
    
    @IBAction func showMixArcrotationAndActivityToast() {
        view.makeToast(JJMixTwoToastItem(first: JJArcrotationToastItem(), second: JJActivityToastItem()))
            .updateItem(options: { options in
                options.layout = .ltr_center
            })
            .duration(.distantFuture)
            .autoDismissOnTap()
            .show()
    }
    
    @IBAction func showMixTextAndWebImageToast() {
        guard let url = URL(string: "http://apng.onevcat.com/assets/elephant.png") else {
            return
        }
        view.makeToast(JJMixTwoToastItem(first: JJTextToastItem(text: "进击的象🐘"), second: JJImageToastItem(url: url, display: { url, imageView in
            imageView.sd_setImage(with: url, completed: nil)
        }))).updateItem(options: { opt in
            opt.secondOptions.imageSize = .fixed(CGSize(width: 150, height: 150))
            opt.secondOptions.configUIImageView = { iv in
                iv.contentMode = .scaleAspectFill
                iv.clipsToBounds = true
            }
        })
        .useContainer(JJGradientContainer(colors: [.jRandom(), .jRandom(), .jRandom()]))
        .autoDismissOnTap()
        .duration(.distantFuture)
        .show()
    }
    
    @IBAction func showCustomAppearAniamtorToast() {
        view.makeToast(JJArcrotationToastItem())
            .appearAnimations([.scaleX(0.2), .opacity(0.3)])
            .autoDismissOnTap()
            .duration(.distantFuture)
            .show(animated: true)
    }
    
    @IBAction func showCustomDisappearAniamtorToast() {
        view.makeToast(JJArcrotationToastItem())
            .disappearAnimations([.scaleY(0.2).opposite, .opacity(0.3).opposite])
            .autoDismissOnTap()
            .duration(.distantFuture)
            .show(animated: true)
    }
}
