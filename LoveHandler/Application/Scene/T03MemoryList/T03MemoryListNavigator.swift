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
}

class T03MemoryListNavigator: T03MemoryListNavigatorType {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func toMemory() {
        let viewController = T04MemoryViewController.instantiateFromStoryboard()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.hero.isEnabled = true
        
        viewController.viewModel = T04MemoryViewModel(navigator: T04MemoryNavigator(controller: viewController),
                                                      useCase: UseCaseProvider.defaultProvider.getMemoryUseCase())

        navigationController.present(viewController,animated: true, completion: nil)
    }
}
