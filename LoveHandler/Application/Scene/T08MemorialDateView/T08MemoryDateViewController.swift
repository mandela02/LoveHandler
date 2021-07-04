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
    
    private var cancellables = Set<AnyCancellable>()

    override func setupView() {
        super.setupView()
        setupDatePicker()
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
                self.startDateTextField.text = date.dayMonthYearString
                Settings.relationshipStartDate.value = date
        }.store(in: &cancellables)
        
        weddingDatePicker.datePublisher
            .sink { [weak self] date in
                guard let self = self else { return }
                self.weddingDateTextField.text = date.dayMonthYearString
                Settings.weddingDate.value = date
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
        startDatePicker.maximumDate = Constant.maxDate
        startDatePicker.minimumDate = Constant.minDate
        startDatePicker.datePickerMode = .date
        startDatePicker.date = SettingsHelper.relationshipStartDate.value
        
        weddingDatePicker.locale = Locale(identifier: Strings.localeIdentifier)
        weddingDatePicker.calendar = Calendar.gregorian
        weddingDatePicker.maximumDate = Constant.maxDate
        weddingDatePicker.minimumDate = Constant.minDate
        weddingDatePicker.datePickerMode = .date
        weddingDatePicker.date = SettingsHelper.weddingDate.value
    }
}
