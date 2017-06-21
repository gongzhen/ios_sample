//
//  AppDelegate+AppService.swift
//  iOS10DrawShapesTutorial
//
//  Created by zhen gong on 6/21/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    func initWindow() {
        let viewController = ViewController()
        let navigationViewController = UINavigationController(rootViewController: viewController)
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationViewController
        self.window?.makeKeyAndVisible()        
    }
}
