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
        let viewController = T03MemoryListViewController.instantiateFromStoryboard()
        let navigationController = BaseNavigationController(rootViewController: viewController)
        let navigator = T03MemoryListNavigator(navigationController: navigationController)
        viewController.viewModel = T03MemoryListViewModel(navigator: navigator,
                                                          useCase: UseCaseProvider.defaultProvider.getMemoryListUseCase())
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isHeroEnabled = true
        navigationController.hero.modalAnimationType = .selectBy(presenting: .pageIn(direction: .up),
                                                                 dismissing: .pageOut(direction: .down))

        self.navigationController.present(navigationController,
                                          animated: true, completion: nil)
    }
}
