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
        let mainViewController = T07TuttorialViewController.instantiateFromStoryboard()
        // let navigator = T01MainViewNavigator(navigationController: navigationController)
        // mainViewController.viewModel = T01MainViewViewModel(navigator: navigator)
        
        navigationController.setViewControllers([mainViewController], animated: false)
            
        window?.rootViewController = navigationController
    }
}
