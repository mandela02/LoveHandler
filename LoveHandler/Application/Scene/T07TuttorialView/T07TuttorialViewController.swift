//
//  T07TuttorialViewController.swift
//  LoveHandler
//
//  Created by LanNTH on 24/06/2021.
//

import UIKit
import Combine

enum TutorialStep {
    case firstStep
    case secondStep
    
    var namePlaceHolder: String {
        switch self {
        case .firstStep:
            return "your name"
        case .secondStep:
            return "your parter name"
        }
    }
    
    var datePlaceHolder: String {
        switch self {
        case .firstStep:
            return "your birthday"
        case .secondStep:
            return "your parter birthday"
        }
    }
}

class T07TuttorialViewController: BaseViewController {
    @IBOutlet weak var avatarImageView: RoundImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let tapGesture = UITapGestureRecognizer(target: self, action: nil)

    private var cancellables = Set<AnyCancellable>()

    private var person = CurrentValueSubject<Person, Never>(Person())
    var tutorialStep: TutorialStep?

    private var isSettingViewController = true
    
    override func refreshView() {
        super.refreshView()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func setupView() {
        avatarImageView.image = Gender.female.defaultImage
        dateTextField.isUserInteractionEnabled = false
        person.value.gender = tutorialStep == .firstStep ? .female : .male
        setupDatePicker()
        if let step = tutorialStep {
            setupPlaceholder(step: step)
        }
    }
    
    override func setupTheme() {
        super.setupTheme()
        genderButton.setTitleColor(UIColor.white, for: .normal)
        avatarImageView.backgroundColor = UIColor.white
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        datePicker.datePublisher.sink { [weak self] date in
            guard let self = self else { return }
            if self.isSettingViewController {
                self.isSettingViewController = false
            } else {
                self.person.value.dateOfBirth = date.timeIntervalSince1970
            }
            self.datePicker.date = date
        }
        .store(in: &cancellables)

        nameTextField.textPublisher.sink { [weak self] value in
            self?.person.value.name = value
        }
        .store(in: &cancellables)
                
        tapGesture.tapPublisher.sink { _ in
        }
        .store(in: &cancellables)
        
        genderButton.tapPublisher.sink {  [weak self] _ in
            UIAlertController.showActionSheet(source: Gender.self,
                                              title: LocalizedString.t01ChooseGenderTitle,
                                              message: LocalizedString.t01ChooseGenderSubTitle) { [weak self] gender in
                guard let self = self else { return }
                self.person.value.gender = gender
            }
        }
        .store(in: &cancellables)
        
        person.sink { [weak self] person in
            guard let self = self else { return }
            
            if let gender = person.gender {
                self.genderButton.setTitle(gender.getName(), for: .normal)
                if person.image == nil {
                    self.avatarImageView.image = gender.defaultImage
                }
            }
            
            if let dateOfBirth = person.dateOfBirth {
                self.dateTextField.text = Date(timeIntervalSince1970: dateOfBirth).dayMonthYearString
            }
        }
        .store(in: &cancellables)
    }
}

extension T07TuttorialViewController {
    func setupPlaceholder(step: TutorialStep) {
        nameTextField.placeholder = step.namePlaceHolder
        dateTextField.placeholder = step.datePlaceHolder
    }
    
    private func setupDatePicker() {
        datePicker.locale = Locale(identifier: Strings.localeIdentifier)
        datePicker.calendar = Calendar.gregorian
        datePicker.maximumDate = Constant.maxDate
        datePicker.minimumDate = Constant.minDate
        datePicker.datePickerMode = .date
    }
    
    private func setupAvatarUserInteraction() {
        avatarImageView.isUserInteractionEnabled = true
    }
}
