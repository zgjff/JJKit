//
//  AttributMakerDemoController.swift
//  Demo
//
//  Created by zgjff on 2022/10/8.
//

import UIKit

class AttributMakerDemoController: UIViewController {

}

extension AttributMakerDemoController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        sourceController.navigationController?.pushViewController(self, animated: true)
    }
}

extension AttributMakerDemoController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "春江花月夜"
        setup()
    }
}

private extension AttributMakerDemoController {
    func setup() {
        let str = """
        张若虚

        春江潮水连海平， 海上明月共潮生。
        滟滟随波千万里， 何处春江无月明。
        江流宛转绕芳甸， 月照花林皆似霰。
        空里流霜不觉飞， 汀上白沙看不见。
        江天一色无纤尘， 皎皎空中孤月轮。
        江畔何人初见月？ 江月何年初照人？
        人生代代无穷已， 江月年年只相似。
        不知江月待何人， 但见长江送流水。
        白云一片去悠悠， 青枫浦上不胜愁。
        谁家今夜扁舟子？ 何处相思明月楼？
        可怜楼上月徘徊， 应照离人妆镜台。
        玉户帘中卷不去， 捣衣砧上拂还来。
        此时相望不相闻， 愿逐月华流照君。
        鸿雁长飞光不度， 鱼龙潜跃水成文。
        昨夜闲潭梦落花， 可怜春半不还家。
        江水流春去欲尽， 江潭落月复西斜。
        斜月沉沉藏海雾， 碣石潇湘无限路。
        不知乘月几人归， 落月摇情满江树。
        """
        var l = UILabel()
        l.numberOfLines = 0
        l.attributedText = str.jj.attributeMake({ make in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineSpacing = 8
            make.all()?.font(UIFont.systemFont(ofSize: 18)).foregroundColor(UIColor.brown).paragraphStyle(paragraphStyle)
            make.for(0, 1, 2)?.font(UIFont.boldSystemFont(ofSize: 20)).foregroundColor(.magenta)
            make.for(42..<45)?.foregroundColor(.green)
            make.for(72...82)?.foregroundColor(.green)
            make.for("春江")?.foregroundColor(.cyan)
            make.for(NSRange(location: 300, length: 201))?.foregroundColor(UIColor.red)
            let regex = JJAttributedRegexp(pattern: "[江?.月]")!
            make.for(regex)?.foregroundColor(.magenta)
        })
        l.sizeToFit()
        l.jj.width = view.jj.width
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.addSubview(l)
        scrollView.backgroundColor = .black
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.jj.width, height: l.jj.height)
    }
}
