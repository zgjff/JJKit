//
//  AppDelegate.swift
//  Demo
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.black
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        registerRouters()
        return true
    }
}

extension AppDelegate {
    private func registerRouters() {
        SimpleRouter.allCases.forEach { try! $0.register() }
        BlockRouter.allCases.forEach { try! $0.register() }
        PassParameterRouter.register()
    }
}
