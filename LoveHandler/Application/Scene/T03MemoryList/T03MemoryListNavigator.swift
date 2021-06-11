//
//  T03MemoryListNavigator.swift
//  LoveHandler
//
//  Created by LanNTH on 10/06/2021.
//

import UIKit

protocol T03MemoryListNavigatorType {
    func dismiss()
}

class T03MemoryListNavigator: T03MemoryListNavigatorType {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
