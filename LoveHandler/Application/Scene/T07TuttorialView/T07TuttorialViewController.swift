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
    
    var genderHolder: String {
        switch self {
        case .firstStep:
            return "your gender"
        case .secondStep:
            return "your parter gender"
        }
    }
}

class T07TuttorialViewController: BaseViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var avatarImageView: RoundImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var skipButton: UIButton!
    
    let tapGesture = UITapGestureRecognizer(target: self, action: nil)

    private var cancellables = Set<AnyCancellable>()

    private var person = CurrentValueSubject<Person, Never>(Person())
    private var tutorialStep = CurrentValueSubject<TutorialStep, Never>(.firstStep)

    override func refreshView() {
        super.refreshView()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func setupView() {
        backgroundImageView.image = ImageNames.love1.image
        avatarImageView.image = Gender.female.defaultImage
        
        dateTextField.isUserInteractionEnabled = false
    }
    
    override func setupTheme() {
        super.setupTheme()
        skipButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitleColor(UIColor.gray, for: .disabled)
        genderButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.backgroundColor = Colors.deepPink
        avatarImageView.backgroundColor = UIColor.white
    }
    
    override func setupLocalizedString() {
        super.setupLocalizedString()
        nextButton.setTitle("NEXT", for: .normal)
        skipButton.setTitle("SKIP", for: .normal)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        datePicker.datePublisher.sink { [weak self] date in
            self?.person.value.dateOfBirth = date
            self?.datePicker.date = date
        }
        .store(in: &cancellables)

        nameTextField.textPublisher.sink { [weak self] value in
            self?.person.value.name = value
        }
        .store(in: &cancellables)
        
        nextButton.tapPublisher.sink { [weak self] _ in
            guard let self = self else { return }
            self.goToNextPage()
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
            self.nextButton.isEnabled = person.isACompletePerson
            
            if let gender = person.gender {
                self.genderButton.setTitle(gender.getName(), for: .normal)
                if person.image == nil {
                    self.avatarImageView.image = gender.defaultImage
                }
            }
            
            if let dateOfBirth = person.dateOfBirth {
                self.dateTextField.text = dateOfBirth.dayMonthYearString
            }
        }
        .store(in: &cancellables)
        
        tutorialStep.sink { [weak self] step in
            guard let self = self else { return }
            self.setupPlaceholder(step: step)
            self.person.send(Person())
        }
        .store(in: &cancellables)
    }
}

extension T07TuttorialViewController {
    private func goToNextPage() {
        if self.tutorialStep.value == .firstStep {
            self.tutorialStep.send(.secondStep)
        } else {}
    }
    func setupPlaceholder(step: TutorialStep) {
        nameTextField.placeholder = step.namePlaceHolder
        dateTextField.placeholder = step.datePlaceHolder
        genderButton.setTitle(step.genderHolder, for: .normal)
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