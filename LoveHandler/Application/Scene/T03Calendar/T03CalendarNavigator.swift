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
    func toNote(with note: Note)
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
        viewController.viewModel = T05NoteViewModel(useCase: UseCaseProvider.defaultProvider.getNotesUseCase())
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func toNote(with note: Note) {
        let viewController = T05NoteViewController.instantiateFromStoryboard()
        viewController.viewModel = T05NoteViewModel(note: note,
                                                    useCase: UseCaseProvider.defaultProvider.getNotesUseCase())
        navigationController.pushViewController(viewController, animated: true)
    }
}
