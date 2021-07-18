//
//  T08MemoryDateViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 03/07/2021.
//

import UIKit
import Combine

class T08MemoryDateViewController: BasePageViewChildController {
    @IBOutlet weak var youView: SmallPersonView!
    @IBOutlet weak var soulMateView: SmallPersonView!
    @IBOutlet weak var startDateTitleLabel: UILabel!
    @IBOutlet weak var weddingDateTItleLabel: UILabel!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var weddingDateTextField: UITextField!
    @IBOutlet weak var weddingDatePicker: UIDatePicker!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    private var cancellables = Set<AnyCancellable>()
    
    var isFromSettingView = false

    override func setupView() {
        super.setupView()
        setupDatePicker()
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
    
    override func bindViewModel() {
        super.bindViewModel()
        startDatePicker.datePublisher
            .sink { [weak self] date in
                guard let self = self else { return }
                self.startDateTextField.text = date.dayMonthYearDayOfWeekString
                Settings.relationshipStartDate.value = date
                self.resetLimit()
        }.store(in: &cancellables)
        
        weddingDatePicker.datePublisher
            .sink { [weak self] date in
                guard let self = self else { return }
                self.weddingDateTextField.text = date.dayMonthYearDayOfWeekString
                Settings.weddingDate.value = date
                self.resetLimit()
        }.store(in: &cancellables)
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        weddingDateTItleLabel.text = LocalizedString.t08WeddingDateTitle
        startDateTitleLabel.text = LocalizedString.t08StartDateTitle
    }
    
    override func setupTheme() {
        super.setupTheme()
        weddingDateTItleLabel.textColor = UIColor.white
        startDateTitleLabel.textColor = UIColor.white
        startDateTextField.textColor = Colors.deepPink
        weddingDateTextField.textColor = Colors.deepPink
    }
    
    private func setupDatePicker() {
        startDatePicker.locale = Locale(identifier: Strings.localeIdentifier)
        startDatePicker.calendar = Calendar.gregorian
        startDatePicker.maximumDate = SettingsHelper.weddingDate.value
        startDatePicker.minimumDate = Constant.minDate
        startDatePicker.datePickerMode = .date
        startDatePicker.date = SettingsHelper.relationshipStartDate.value
        
        weddingDatePicker.locale = Locale(identifier: Strings.localeIdentifier)
        weddingDatePicker.calendar = Calendar.gregorian
        weddingDatePicker.maximumDate = Constant.maxDate
        weddingDatePicker.minimumDate = SettingsHelper.relationshipStartDate.value
        weddingDatePicker.datePickerMode = .date
        weddingDatePicker.date = SettingsHelper.weddingDate.value
    }
    
    private func resetLimit() {
        startDatePicker.maximumDate = SettingsHelper.weddingDate.value > Date() ?  Date() : SettingsHelper.weddingDate.value
        weddingDatePicker.minimumDate = SettingsHelper.relationshipStartDate.value
    }
    
    private func setupBackground(data: Data?) {
        guard let data = data else {
            backgroundImageView.image = ImageNames.love1.image
            return
        }
        backgroundImageView.image = UIImage(data: data)
    }
}
