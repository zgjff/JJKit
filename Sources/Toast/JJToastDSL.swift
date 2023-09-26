//
//  JJToastDSL.swift
//  JJToast
//
//  Created by zgjff on 2023/8/8.
//

import UIKit

/// `totast`链式操作
public class JJToastDSL<T> where T: JJToastItemable {
    private var item: T
    private var itemOptions = T.Options.init()
    private unowned let view: UIView
    private var containerOptions = JJToastContainerOptions()
    private var container: any JJToastContainer
    internal init(view: UIView, item: T) {
        self.view = view
        self.item = item
        container = JJBlurEffectContainer()
    }
}

// MARK: - Config
public extension JJToastDSL {
    /// 修改`JJToastItemable`的配置
    /// - Parameter block: block配置
    func updateItem(options block: (_ options: inout T.Options) -> ()) -> Self {
        block(&itemOptions)
        return self
    }
    
    /// 更换显示容器
    func useContainer(_ container: any JJToastContainer) -> Self {
        self.container = container
        return self
    }
    
    /// 设置显示容器的圆角
    func cornerRadius(_ cornerRadius: JJToastContainerOptions.CornerRadius) -> Self {
        containerOptions.cornerRadius = cornerRadius
        return self
    }
    
    /// 设置显示容器的圆角位置
    func corners(_ corners: UIRectCorner) -> Self {
        containerOptions.corners = corners
        return self
    }
    
    /// 设置显示时间
    func duration(_ duration: JJToastDuration) -> Self {
        containerOptions.duration = duration
        return self
    }
    
    /// 设置显示位置
    func position(_ position: JJToastPosition) -> Self {
        containerOptions.postition = position
        return self
    }
    
    /// 设置容器的显示动画
    func appearAnimations(_ appearAnimations: Set<JJContainerAnimator>) -> Self {
        containerOptions.appearAnimations = appearAnimations
        return self
    }
    
    /// 设置容器的隐藏动画
    func disappearAnimations(_ disappearAnimations: Set<JJContainerAnimator>) -> Self {
        containerOptions.disappearAnimations = disappearAnimations
        return self
    }
    
    /// 设置容器的显示动画的相反动画为隐藏动画
    func useOppositeAppearAnimationsForDisappear() -> Self {
        containerOptions.disappearAnimations = containerOptions.oppositeOfAppearAnimations()
        return self
    }
    
    /// 已经显示回调
    func didAppear(block: @escaping () -> ()) -> Self {
        containerOptions.onAppear = block
        return self
    }
    
    /// 已经消失回调
    func didDisappear(block: @escaping () -> ()) -> Self {
        containerOptions.onDisappear = block
        return self
    }
    
    /// 点击回调
    func didTap(block: @escaping (_ toast: any JJToastContainer) -> ()) -> Self {
        containerOptions.onTap = block
        return self
    }
    
    /// 点击自动消失
    func autoDismissOnTap() -> Self {
        containerOptions.onTap = { container in
            container.dismiss(animated: true)
        }
        return self
    }
}

public extension JJToastDSL {
    /// 显示toast
    /// - Parameter animated: 是否开启动画
    @discardableResult
    func show(animated flag: Bool = true) -> any JJToastContainer {
        item.delegate = container
        container.options = containerOptions
        item.layoutToastView(with: itemOptions, inViewSize: view.bounds.size)
        container.present(view, animated: flag)
        return container
    }
}
