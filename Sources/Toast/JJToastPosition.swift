//
//  JJToastPosition.swift
//  JJToast
//
//  Created by zgjff on 2023/8/9.
//

import UIKit

/// Toast的显示位置
public struct JJToastPosition {
    private let centerYRatio: CGFloat
    private let offset: CGFloat
    private let ignoreSafeAreaInsets: Bool
    /// 初始化ToastPosition
    /// - Parameters:
    ///   - centerYRatio: taost container的中心点占superView的比例,具体算法为
    ///
    ///         containerView.centerY/(superView.height - containerView.height - superView.safeAreaInsets.top - superView.safeAreaInsets.bottom)
    ///
    ///   - offset: centerY的偏移量
    ///   - ignoreSafeAreaInsets: 是否忽略安全区域
    public init(centerYRatio: CGFloat, offset: CGFloat, ignoreSafeAreaInsets: Bool = false) {
        self.centerYRatio = centerYRatio
        self.offset = offset
        self.ignoreSafeAreaInsets = ignoreSafeAreaInsets
    }
}

extension JJToastPosition {
    /// 忽略安全区域的顶部
    public static var top = JJToastPosition(centerYRatio: 0, offset: 0, ignoreSafeAreaInsets: true)
    /// 不忽略安全区域顶部
    public static var safeTop = JJToastPosition(centerYRatio: 0, offset: 0, ignoreSafeAreaInsets: false)
    /// 忽略安全区域的四分之一处
    public static var quarter = JJToastPosition(centerYRatio: 0.25, offset: 0, ignoreSafeAreaInsets: true)
    /// 不忽略安全区域的四分之一处
    public static var safeQuarter = JJToastPosition(centerYRatio: 0.25, offset: 0, ignoreSafeAreaInsets: false)
    /// 忽略安全区域的中心处
    public static var center = JJToastPosition(centerYRatio: 0.5, offset: 0, ignoreSafeAreaInsets: true)
    /// 不忽略安全区域的中心处
    public static var safeCenter = JJToastPosition(centerYRatio: 0.5, offset: 0, ignoreSafeAreaInsets: false)
    /// 忽略安全区域的四分之三处
    public static var threeQuarter = JJToastPosition(centerYRatio: 0.75, offset: 0, ignoreSafeAreaInsets: true)
    /// 不忽略安全区域的四分之三处
    public static var safeThreeQuarter = JJToastPosition(centerYRatio: 0.75, offset: 0, ignoreSafeAreaInsets: false)
    /// 忽略安全区域的底部
    public static var bottom = JJToastPosition(centerYRatio: 1, offset: 0, ignoreSafeAreaInsets: true)
    /// 不忽略安全区域低部
    public static var safeBottom = JJToastPosition(centerYRatio: 1, offset: 0, ignoreSafeAreaInsets: false)
}

extension JJToastPosition {
    internal func centerForContainer(_ container: JJToastContainer, inView superView: UIView) -> CGPoint {
        let cx = superView.bounds.width * 0.5
        let containerSize = container.bounds.size
        if containerSize.height == 0 {
            return CGPoint(x: cx, y: 0)
        }
        let cy: CGFloat
        switch ignoreSafeAreaInsets {
        case false:
            let safeAreaHeight = superView.bounds.height - containerSize.height - superView.safeAreaInsets.top - superView.safeAreaInsets.bottom
            cy = safeAreaHeight * centerYRatio + offset + containerSize.height * 0.5 + superView.safeAreaInsets.top
        case true:
            let areaHeight = superView.bounds.height - containerSize.height
            cy = areaHeight * centerYRatio + offset + containerSize.height * 0.5
        }
        return CGPoint(x: cx, y: cy)
    }
}

extension JJToastPosition: Equatable {
    public static func == (lhs: JJToastPosition, rhs: JJToastPosition) -> Bool {
        return (lhs.ignoreSafeAreaInsets == rhs.ignoreSafeAreaInsets) && (lhs.centerYRatio == rhs.centerYRatio) && (lhs.offset == rhs.offset)
    }
}
