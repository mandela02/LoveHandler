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
    }
    
    func toDiaries() {
    }
}
