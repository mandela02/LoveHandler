//
//  T2SettingsNavigator.swift
//  LoveHandler
//
//  Created by LanNTH on 20/04/2021.
//

import Foundation
import DatePickerDialog
import Combine

protocol T2SettingsNavigatorType {
    func dismiss()
    func datePicker(title: String, date: Date, minDate: Date, maxDate: Date) -> Future<Date?, Never>
    func toBackgroundView()
}

class T2SettingsNavigator: T2SettingsNavigatorType {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func dismiss() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func datePicker(title: String, date: Date, minDate: Date, maxDate: Date) -> Future<Date?, Never> {
        return Future() { promise in
            let dialog = DatePickerDialog(textColor: Colors.paleVioletRed,
                                          buttonColor: Colors.mediumVioletRed,
                                          locale: Locale(identifier: Strings.localeIdentifier))
            dialog.overrideUserInterfaceStyle = .light
            dialog.datePicker.overrideUserInterfaceStyle = .light
            dialog.show(title,
                        doneButtonTitle: LocalizedString.t01ConfirmButtonTitle,
                        cancelButtonTitle: LocalizedString.t01CancelButtonTitle,
                        defaultDate: date,
                        minimumDate: minDate,
                        maximumDate: maxDate,
                        datePickerMode: .date) { selectedDate in
                promise(.success(selectedDate))
            }
        }
    }
    
    func toBackgroundView() {
        let viewController = T05BackgroundViewController.instantiateFromStoryboard()
        viewController.viewModel = T05BackgroundViewModel(useCase: UseCaseProvider.defaultProvider.getBackgroundSettingUseCase())
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
