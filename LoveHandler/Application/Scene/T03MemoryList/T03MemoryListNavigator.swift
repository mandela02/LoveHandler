//
//  T03MemoryListNavigator.swift
//  LoveHandler
//
//  Created by LanNTH on 10/06/2021.
//

import UIKit

protocol T03MemoryListNavigatorType {
    func dismiss()
    func toMemory()
    func toMemory(model: CDMemory)
}

class T03MemoryListNavigator: T03MemoryListNavigatorType {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func dismiss() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func toMemory() {
        let viewController = T04MemoryViewController.instantiateFromStoryboard()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.hero.isEnabled = true
        let navigator = T04MemoryNavigator(controller: viewController)
        
        viewController.viewModel = T04MemoryViewModel(navigator: navigator,
                                                      useCase: UseCaseProvider.defaultProvider.getMemoryUseCase())

        navigationController?.present(viewController,animated: true, completion: nil)
    }
    
    func toMemory(model: CDMemory) {
        let viewController = T04MemoryViewController.instantiateFromStoryboard()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.hero.isEnabled = true
        let navigator = T04MemoryNavigator(controller: viewController)
        
        viewController.viewModel = T04MemoryViewModel(navigator: navigator,
                                                      useCase: UseCaseProvider.defaultProvider.getMemoryUseCase(),
                                                      memory: model)
        navigationController?.present(viewController,animated: true, completion: nil)
    }

}
