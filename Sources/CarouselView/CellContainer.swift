//
//  CellContainer.swift
//  JJCarouselView
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

extension JJCarouselView {
    /// 轮播图cell+index的容器类
    final class CellContainer {
        var onTap: ((Cell, Int) -> ())?
        init(cell: Cell, index: Int) {
            cell.isUserInteractionEnabled = true
            self.cell = cell
            self.index = index
            self.cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickCell)))
        }
        let cell: Cell
        var index = 0
        
        @IBAction private func onClickCell() {
            onTap?(cell, index)
        }
    }
}
