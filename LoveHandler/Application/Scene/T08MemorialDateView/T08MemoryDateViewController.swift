//
//  T08MemoryDateViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 03/07/2021.
//

import UIKit
import Combine
import DatePickerDialog

class T08MemoryDateViewController: BasePageViewChildController {
    @IBOutlet weak var youView: SmallPersonView!
    @IBOutlet weak var soulMateView: SmallPersonView!
    @IBOutlet weak var startDateTitleLabel: UILabel!
    @IBOutlet weak var weddingDateTitleLabel: UILabel!
    
    @IBOutlet weak var startDateLabel: BaseLabel!
    @IBOutlet weak var endDateLabel: BaseLabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    private var cancellables = Set<AnyCancellable>()
    
    var isFromSettingView = false
    
    override func setupView() {
        super.setupView()
        setupLabelTap()
        
        self.endDateLabel.text = Settings.weddingDate.value.dayMonthYearDayOfWeekString
        self.startDateLabel.text = Settings.relationshipStartDate.value.dayMonthYearDayOfWeekString

        if isFromSettingView {
            setupBackground(data: SettingsHelper.backgroundImage.value)
            setupPerson()
        }
    }
    
    func setupPerson() {
        youView.setupView(with: Person.get(fromKey: .you))
        soulMateView.setupView(with: Person.get(fromKey: .soulmate))
    }
    
    override func refreshView() {
        super.refreshView()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        weddingDateTitleLabel.text = LocalizedString.t08WeddingDateTitle
        startDateTitleLabel.text = LocalizedString.t08StartDateTitle
    }
    
    override func setupTheme() {
        super.setupTheme()
        weddingDateTitleLabel.textColor = UIColor.white
        startDateTitleLabel.textColor = UIColor.white
        startDateLabel.textColor = Colors.deepPink
        endDateLabel.textColor = Colors.deepPink
    }
    
    private func setupGesture() {
        
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        if sender.view == startDateLabel {
            startDatePickerTapped()
        } else {
            endDatePickerTapped()
        }
    }
    
    func setupLabelTap() {
        let startLabelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        startDateLabel.isUserInteractionEnabled = true
        startDateLabel.addGestureRecognizer(startLabelTap)
        let endLabelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        endDateLabel.isUserInteractionEnabled = true
        endDateLabel.addGestureRecognizer(endLabelTap)
    }
    
    private func startDatePickerTapped() {
        let dialog = DatePickerDialog(textColor: Colors.paleVioletRed,
                                      buttonColor: Colors.mediumVioletRed,
                                      locale: Locale(identifier: Strings.localeIdentifier))
        
        dialog.overrideUserInterfaceStyle = .light
        dialog.datePicker.overrideUserInterfaceStyle = .light
        
        dialog.show(LocalizedString.t01DatePickerTitleTitle,
                    doneButtonTitle: LocalizedString.t01ConfirmButtonTitle,
                    cancelButtonTitle: LocalizedString.t01CancelButtonTitle,
                    defaultDate: SettingsHelper.relationshipStartDate.value,
                    minimumDate: Constant.minDate,
                    maximumDate: SettingsHelper.weddingDate.value,
                    datePickerMode: .date) { [weak self] date in
            guard let self = self else { return }
            if let date = date {
                self.startDateLabel.text = date.dayMonthYearDayOfWeekString
                Settings.relationshipStartDate.value = date
            }
        }
    }
    
    private func endDatePickerTapped() {
        let dialog = DatePickerDialog(textColor: Colors.paleVioletRed,
                                      buttonColor: Colors.mediumVioletRed,
                                      locale: Locale(identifier: Strings.localeIdentifier))
        
        dialog.overrideUserInterfaceStyle = .light
        dialog.datePicker.overrideUserInterfaceStyle = .light
        
        dialog.show(LocalizedString.t01DatePickerTitleTitle,
                    doneButtonTitle: LocalizedString.t01ConfirmButtonTitle,
                    cancelButtonTitle: LocalizedString.t01CancelButtonTitle,
                    defaultDate: SettingsHelper.weddingDate.value,
                    minimumDate: SettingsHelper.relationshipStartDate.value,
                    maximumDate: Constant.maxDate,
                    datePickerMode: .date) { [weak self] date in
            guard let self = self else { return }
            if let date = date {
                self.endDateLabel.text = date.dayMonthYearDayOfWeekString
                Settings.weddingDate.value = date
            }
        }
    }
    
    private func setupBackground(data: Data?) {
        guard let data = data else {
            backgroundImageView.image = ImageNames.love1.image
            return
        }
        backgroundImageView.image = UIImage(data: data)
    }
}
