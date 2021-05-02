//
//  T03CalendarNavigator.swift
//  LoveHandler
//
//  Created by LanNTH on 30/04/2021.
//

import Foundation
import UIKit

protocol T03CalendarNavigatorType {
    func dissmiss()
    func toNote()
}

class T03CalendarNavigator: T03CalendarNavigatorType {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func dissmiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func toNote() {
        let viewController = T05NoteViewController.instantiateFromStoryboard()
        viewController.viewModel = T05NoteViewModel()
        navigationController.pushViewController(viewController, animated: true)
    }
}
