//
//  AppNavigator.swift
//  LoveHandler
//
//  Created by LanNTH on 16/04/2021.
//

import UIKit

protocol AppNavigatorType {
    var window: UIWindow? { get }
    func setRootViewController()
}

class AppNavigator: AppNavigatorType {
    var window: UIWindow?
        
    init(window: UIWindow?) {
        self.window = window
        setRootViewController()
    }
    
    func setRootViewController() {
        let navigationController = BaseNavigationController()
        let mainViewController = T07TutorialContainerViewController.instantiateFromStoryboard()
        
        navigationController.setViewControllers([mainViewController], animated: false)
            
        window?.rootViewController = navigationController
    }
}
