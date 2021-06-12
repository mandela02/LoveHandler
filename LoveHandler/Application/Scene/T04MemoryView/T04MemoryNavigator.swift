//
//  T04MemoryNavigator.swift
//  LoveHandler
//
//  Created by LanNTH on 12/06/2021.
//

import Foundation
import Combine
import UIKit
import DatePickerDialog

protocol T04MemoryNavigatorType {
    func dismiss()
    func datePicker(title: String, date: Date, minDate: Date, maxDate: Date) -> Future<Date?, Never>
}

class T04MemoryNavigator: T04MemoryNavigatorType {
    private let controller: UIViewController
    
    init(controller: UIViewController) {
        self.controller = controller
    }

    func dismiss() {
        controller.dismiss(animated: true, completion: nil)
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
}
