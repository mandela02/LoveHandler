//
//  T2SettingsNavigator.swift
//  LoveHandler
//
//  Created by LanNTH on 20/04/2021.
//

import Foundation
import DatePickerDialog

protocol T2SettingsNavigatorType {
    func dismiss()
    func datePicker(title: String, date: Date, minDate: Date, maxDate: Date) -> Single<Date?>
}

class T2SettingsNavigator: T2SettingsNavigatorType {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func datePicker(title: String, date: Date, minDate: Date, maxDate: Date) -> Single<Date?> {
        return Single.create { single in
            let dialog = DatePickerDialog(locale: Locale(identifier: Strings.localeIdentifier))
            dialog.overrideUserInterfaceStyle = .light
            dialog.datePicker.overrideUserInterfaceStyle = .light
            dialog.show(title,
                        doneButtonTitle: LocalizedString.t01ConfirmButtonTitle,
                        cancelButtonTitle: LocalizedString.t01CancelButtonTitle,
                        defaultDate: date,
                        minimumDate: minDate,
                        maximumDate: maxDate,
                        datePickerMode: .date) { date in
                single(.success(date))
            }
            return Disposables.create()
        }
    }
}
