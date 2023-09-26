//
//  JJToastContainerOptions.swift
//  JJToast
//
//  Created by zgjff on 2023/8/9.
//

import UIKit

extension JJToastContainerOptions {
    /// 圆角
    public enum CornerRadius {
        /// 固定大小
        case fix(CGFloat)
        /// 高度的一半: 大小随高度变化
        case halfHeight
    }
}

/// 容器配置
public struct JJToastContainerOptions {
    /// 显示动画key
    static let layerShowAnimationKey = "showJJToastContainerGroupAnimations"
    /// 隐藏动画key
    static let layerDismissAnimationKey = "hideJJToastContainerGroupAnimations"
    /// 显示隐藏动画时间
    internal var showOrHiddenAnimationDuration = 0.15
    /// 圆角大小: 默认8
    internal var cornerRadius = CornerRadius.fix(8)
    /// 圆角位置
    internal var corners = UIRectCorner.allCorners
    /// 显示时间
    internal var duration = JJToastDuration.seconds(2)
    /// 显示位置
    internal var postition = JJToastPosition.center
    /// 显示动画
    internal var appearAnimations: Set<JJContainerAnimator> = [.scale(0.7)]
    /// 隐藏动画
    internal var disappearAnimations: Set<JJContainerAnimator> = [.scale(0.7).opposite, .opacity(0).opposite]
    /// 显示回调
    internal var onAppear: (() -> ())?
    /// 消失回调
    internal var onDisappear: (() -> ())?
    /// 点击回调
    internal var onTap: ((JJToastContainer) -> ())?
}

extension JJToastContainerOptions {
    internal func oppositeOfAppearAnimations() -> Set<JJContainerAnimator> {
        return appearAnimations.reduce([]) { partialResult, animatior in
            var reslut = partialResult
            reslut.insert(animatior.opposite)
            return reslut
        }
    }
    
    @discardableResult
    internal func startAppearAnimations(for view: UIView) -> CAAnimation? {
        return handleAnimations(appearAnimations, forView: view, isShow: true)
    }
    
    @discardableResult
    internal func startHiddenAnimations(for view: UIView) -> CAAnimation? {
        return handleAnimations(disappearAnimations, forView: view, isShow: false)
    }
    
    @discardableResult
    private func handleAnimations(_ animations: Set<JJContainerAnimator>, forView view: UIView, isShow: Bool) -> CAAnimation? {
        if animations.isEmpty {
            return nil
        }
        let group = CAAnimationGroup()
        group.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        group.duration = showOrHiddenAnimationDuration
        group.animations = animations.map { $0.animation }
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        return group
    }
    
    internal func layerAnimationKey(forShow flag: Bool) -> String {
        return flag ? JJToastContainerOptions.layerShowAnimationKey : JJToastContainerOptions.layerDismissAnimationKey
    }
}
