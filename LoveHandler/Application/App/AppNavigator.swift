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
        if Settings.isCompleteSetting.value {
            let navigationController = BaseNavigationController()
            let mainViewController = T01MainViewController.instantiateFromStoryboard()
            let navigator = T01MainViewNavigator(navigationController: navigationController)
            mainViewController.viewModel = T01MainViewViewModel(navigator: navigator)
            navigationController.setViewControllers([mainViewController], animated: false)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            UIView.transition(with: window ?? UIWindow(),
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil, completion: nil)
        } else {
            
            let navigationController = BaseNavigationController()
            let mainViewController = T07TutorialContainerViewController.instantiateFromStoryboard()
            
            navigationController.setViewControllers([mainViewController], animated: false)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
}
