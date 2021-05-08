//
//  T01MainViewNavigator.swift
//  LoveHandler
//
//  Created by LanNTH on 19/04/2021.
//

import UIKit

protocol T01MainViewNavigatorType {
    func toSettings()
    func toDiaries()
}

class T01MainViewNavigator: T01MainViewNavigatorType {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toSettings() {
        let viewController = T02SettingsViewController.instantiateFromStoryboard()
        let navigationController = BaseNavigationController(rootViewController: viewController)
        let navigator = T2SettingsNavigator(navigationController: navigationController)
        viewController.viewModel = T02SettingsViewModel(navigator: navigator)
        self.navigationController.present(navigationController,
                                          animated: true, completion: nil)
        
    }
    
    func toDiaries() {
        let viewController = T03CalendarViewController.instantiateFromStoryboard()
        let navigationController = BaseNavigationController(rootViewController: viewController)
        let navigator = T03CalendarNavigator(navigationController: navigationController)
        viewController.viewModel = T03CalendarViewModel(navigator: navigator,
                                                        useCase: UseCaseProvider.defaultProvider.getCalendarUseCase())
        self.navigationController.present(navigationController,
                                          animated: true, completion: nil)
    }
}
