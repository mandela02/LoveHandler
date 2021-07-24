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
    func toLanguage()
    func toAnniversary()
    func toAnimationSetting()
    func shareAppToFriend(appUrl: String)
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
        return Future { promise in
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
    
    func toLanguage() {
        let viewController = T11LanguageViewController.instantiateFromStoryboard()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func toAnniversary() {
        let viewController = T08MemoryDateViewController.instantiateFromStoryboard()
        viewController.isFromSettingView = true
        self.navigationController?.present(viewController, animated: true, completion: nil)
    }
    
    func toAnimationSetting() {
        let viewController = T12AnimationSettingViewController.instantiateFromStoryboard()
        self.navigationController?.present(viewController, animated: true, completion: nil)
    }
    
    func shareAppToFriend(appUrl: String) {
        let shareText = LocalizedString.appName + "\n"
        guard let shareWebsite = NSURL(string: appUrl) else { return }
        let shareItems = [shareText, shareWebsite] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareItems,
                                                              applicationActivities: nil)
        UIApplication.topViewController()?
            .present(activityViewController,
                     animated: true,
                     completion: nil)
    }
}
